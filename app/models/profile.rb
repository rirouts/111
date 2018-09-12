# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user
  has_many :profile_providers
  has_many :providers, through: :profile_providers
  validates :name, presence: true

  has_many :allergy_intolerances
  has_many :care_plans
  has_many :conditions
  has_many :devices
  has_many :documents
  has_many :encounters
  has_many :goals
  has_many :immunizations
  has_many :medication_administrations
  has_many :medication_requests
  has_many :medication_statements
  has_many :observations
  has_many :procedures
  has_many :explanation_of_benefits
  has_many :coverages
  has_many :claims
  has_many :operation_outcomes # internal OperationOutcomes from deconflicting resources
  # IMPORTANT - if adding new resource types above,
  #             also add them to the all_resources method below

  # resources are the raw resources that are created from transactions, they
  # do not equate to the currated data models resources
  has_many :resources

  def has_provider?(provider_id)
    return false if provider_id.nil?
    !providers.find_by(id: provider_id).nil?
  end

  def all_resources
    # there are hackish ways to do this, but not worth it at this point
    types = %i[allergy_intolerances care_plans conditions devices
               documents encounters goals immunizations
               medication_administrations medication_requests
               medication_statements observations procedures
               explanation_of_benefits coverages claims operation_outcomes]

    rs = []

    types.each do |t|
      rs_by_type = send(t)
      rs.push(*rs_by_type)
    end

    rs
  end

  def to_patient
    FHIR::Patient.new(id: id,
                      name: [{ given: [first_name],
                               family: last_name,
                               use: 'official' }],
                      gender: gender)
  end

  def bundle_everything
    bundle = wrap_in_bundle(all_resources)
    bundle.entry.insert(0, resource: to_patient.to_hash)
    bundle
  end

  def reference
    "Patient/#{patient_id}"
  end

  private

  # TODO: find a common location for this functions and the one in CuratedModelsController
  def wrap_in_bundle(results)
    # get just the FHIR resources, but then wrap it in an Entry.
    resources = results.map { |r| { resource: r.fhir_model.to_hash } }
    FHIR::Bundle.new(type: 'searchset', entry: resources)
  end
end
