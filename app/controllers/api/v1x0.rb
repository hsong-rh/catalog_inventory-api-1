module Api
  module V1x0
    class RootController < ApplicationController
      def openapi
        render :json => ::Insights::API::Common::OpenApi::Docs.instance["1.0"].to_json
      end
    end

    class GraphqlController                     < Api::V1::GraphqlController; end
    class ServiceInstanceNodesController        < Api::V1::ServiceInstanceNodesController; end
    class ServiceInstancesController            < Api::V1::ServiceInstancesController; end
    class ServiceInventoriesController          < Api::V1::ServiceInventoriesController; end
    class ServiceOfferingIconsController        < Api::V1::ServiceOfferingIconsController; end
    class ServiceOfferingNodesController        < Api::V1::ServiceOfferingNodesController; end
    class ServiceOfferingsController            < Api::V1::ServiceOfferingsController; end
    class ServicePlansController                < Api::V1::ServicePlansController; end
    class SourcesController                     < Api::V1::SourcesController; end
    class TagsController                        < Api::V1::TagsController; end
    class TasksController                       < Api::V1::TasksController; end
  end
end
