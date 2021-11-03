# frozen_string_literal: true

class FhirUtilities
  attr_accessor :fhir, :fhir_string

  def initialize
    # This branch is specifically for FHIR R4
    @fhir = FHIR
    @fhir_string = @fhir.name
  end
end
