# frozen_string_literal: true

class FhirUtilities
  attr_accessor :fhir, :fhir_string

  def initialize
    # This branch is specifically for DSTU2
    @fhir = FHIR::DSTU2
    @fhir_string = @fhir.name
  end
end
