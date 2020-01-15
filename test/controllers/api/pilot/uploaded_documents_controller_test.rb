# frozen_string_literal: true

require 'test_helper'

module Api
  module Pilot
    class UploadedDocumentsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = users(:harry)
        @token = generate_token(@user.id)
        @profile = @user.profiles.first
      end

      test 'should get index' do
        get api_pilot_uploaded_documents_url, params: { profile_id: @profile.to_param, access_token: @token.token }
        assert_response :success
      end

      test 'should create uploaded_document' do
        assert_difference('UploadedDocument.count') do
          # Upload a document.
          document = fixture_file_upload('files/uploaded_documents/document.txt')
          post api_pilot_uploaded_documents_url, params:
          {
            uploaded_document: { profile_id: @profile.to_param, document: document },
            access_token: @token.token
          }
          assert_response 201
        end
      end

      # test 'should show uploaded_document' do
      #   get uploaded_document_url(@uploaded_document), as: :json
      #   assert_response :success
      # end

      # test 'should destroy uploaded_document' do
      #   assert_difference('UploadedDocument.count', -1) do
      #     delete uploaded_document_url(@uploaded_document), as: :json
      #   end

      #   assert_response 204
      # end
    end
  end
end
