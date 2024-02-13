# frozen_string_literal: true

module ResourceResponseHandling
  extend ActiveSupport::Concern

  included do
    def respond_with_resource(resource, notice: "")
      respond_to do |format|
        if resource.save
          format.html { redirect_to resource_path(resource), notice: }
          format.json { render :show, status: :created, location: resource }
        else
          format.html { render resource.new_record? ? :new : :edit, status: :unprocessable_entity }
          format.json { render json: resource.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy_resource(resource, notice: "")
      resource.destroy
      respond_to do |format|
        format.html { redirect_to resource_url(resource), notice: }
        format.json { head :no_content }
      end
    end

    private

    def resource_path(resource)
      public_send(:"#{resource.class.name.underscore}_path", resource)
    end

    def resource_url(resource)
      public_send(:"#{resource.class.name.underscore}s_url")
    end
  end
end
