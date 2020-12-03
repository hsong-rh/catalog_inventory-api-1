module Api
  module V2x0
    class RootController < ApplicationController
      def openapi
        render :json => ::Insights::API::Common::OpenApi::Docs.instance["2.0"].to_json
      end
    end

    # Same behavior as api/v1.0/
    class GraphqlController                     < Api::V1x0::GraphqlController; end
    class ServiceInstanceNodesController        < Api::V1x0::ServiceInstanceNodesController; end
    class ServiceInstancesController            < Api::V1x0::ServiceInstancesController; end
    class ServiceInventoriesController          < Api::V1x0::ServiceInventoriesController; end
    class ServiceOfferingIconsController        < Api::V1x0::ServiceOfferingIconsController; end
    class ServiceOfferingNodesController        < Api::V1x0::ServiceOfferingNodesController; end
    class ServiceOfferingsController            < Api::V1x0::ServiceOfferingsController; end
    class ServicePlansController                < Api::V1x0::ServicePlansController; end
    class SourcesController                     < Api::V1x0::SourcesController; end
    class TagsController                        < Api::V1x0::TagsController; end
    class TasksController                       < Api::V1x0::TasksController; end
  end
end
