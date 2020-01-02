# frozen_string_literal: true

module Api
  module Pilot
    class UploadedDocumentsController < ApplicationController
      before_action :set_uploaded_document, only: %i[show download destroy]

      # GET /api/pilot/uploaded_documents
      def index
        # Grab just the uploaded documents for the given profile
        profile = Profile.find params[:profile_id]
        return render json: { 'error': 'Invalid profile: does not belong to access token' }, status: :forbidden unless profile_owned_by_current_user?(profile)

        @uploaded_documents = profile.uploaded_documents

        render json: @uploaded_documents
      end

      # GET /api/pilot/uploaded_documents/1
      # This is kept to download metadata
      def show
        render json: @uploaded_document
      end

      # GET /api/pilot/uploaded_documents/1/download
      def download
        # First, make sure that the current active user is allowed to do this
        unless profile_owned_by_current_user?(@uploaded_document.profile)
          return render json: { 'error': 'Invalid profile for current access token' }, status: :forbidden
        end

        redirect_to rails_blob_path(@uploaded_document.document, disposition: 'attachment')
      end

      # POST /api/pilot/uploaded_documents
      def create
        @uploaded_document = UploadedDocument.new(uploaded_document_params)
        # Check to make sure the profile_id given belongs to the current user

        return render json: { 'error': 'Bad profile ID' }, status: :forbidden if @uploaded_document.profile.nil?

        unless profile_owned_by_current_user?(@uploaded_document.profile)
          return render json: { 'error': 'Invalid profile: does not belong to access token' }, status: :forbidden
        end

        # Note that this doesn't mark document as permitted and wouldn't work if
        # passed to new. Which doesn't matter in this case
        document = params.require(:uploaded_document).require(:document)
        @uploaded_document.document.attach(document)

        if @uploaded_document.save
          render json: @uploaded_document, status: :created, location: api_pilot_uploaded_document_url(@uploaded_document)
        else
          render json: @uploaded_document.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/pilot/uploaded_documents/1
      # def update
      #   if @uploaded_document.update(uploaded_document_params)
      #     render json: @uploaded_document
      #   else
      #     render json: @uploaded_document.errors, status: :unprocessable_entity
      #   end
      # end

      # DELETE /api/pilot/uploaded_documents/1
      def destroy
        @uploaded_document.destroy
      end

      private

      def set_uploaded_document
        @uploaded_document = UploadedDocument.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def uploaded_document_params
        params.require(:uploaded_document).permit(:profile_id)
      end
    end
  end
end
