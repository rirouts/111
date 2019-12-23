# frozen_string_literal: true

# A document that the user has uploaded.
class UploadedDocument < ApplicationRecord
  belongs_to :profile
  has_one_attached :document

  def as_json(*args)
    json = super
    if document.attached?
      json[:filename] = document.filename
    end
    json
  end
end
