# frozen_string_literal: true

# A document that the user has uploaded.
class UploadedDocument < ApplicationRecord
  belongs_to :profile
  has_one_attached :document
end
