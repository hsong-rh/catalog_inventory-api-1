/*
 * Requires: https://github.com/RedHatInsights/insights-pipeline-lib
 */

@Library("github.com/RedHatInsights/insights-pipeline-lib") _

// this 'if' statement makes sure this is a PR, so we don't run smoke tests again
// after code has been merged into the stable branch.
if (env.CHANGE_ID) {
    runSmokeTest (
        // the service-set/component for this app in e2e-deploy "buildfactory"
        ocDeployerBuilderPath: "catalog-inventory/catalog-inventory-api",
        // the service-set/component for this app in e2e-deploy "templates"
        ocDeployerComponentPath: "catalog-inventory/catalog-inventory-api",
        // the service sets to deploy into the test environment
        ocDeployerServiceSets: "platform-mq,sources,catalog-inventory",
        // the iqe plugins to install for the test
        iqePlugins: ["iqe-topology_inventory-plugin"],
        // the pytest marker to use when calling `iqe tests all`
        pytestMarker: "topology_smoke",
        // Config file for tests
       configFileCredentialsId: "catalog-inventory-config"
    )
}
