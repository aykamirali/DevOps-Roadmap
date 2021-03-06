@Library('roche-upath-jenkins-lib@upc14-st2dev') _

"""Pipeline has support for creating "Shared Libraries" which can be defined in external source control repositories and loaded into existing Pipelines.
   where is it this library?
   To access other shared libraries, the Jenkinsfile needs to use the @Library annotation, specifying the library’s name:

   @Library('my-shared-library') _
/* Using a version specifier, such as branch, tag, etc */
@Library('my-shared-library@1.0') _
/* Accessing multiple libraries with one statement */
@Library(['my-shared-library', 'otherlib@abc1234'])





 """

fileNameMap = [dev: "upc-dev", int: "upc-int", qa: "upc-qa", staging: "upc-stage", sit: "upc-sit", prod: "upc-prod"]

pipeline {
    agent any

    """Execute the Pipeline, or stage, on an agent available in the Jenkins environment with the provided label. For example: agent { label 'my-defined-label' }"""


    //deleteStackBeforeDeploy=false;triggerBuildBeforeDeploy=true;deployCoreStack=true;deploySchemaMigratorLambda=true;deployTenantOnboardingLambda=true;createVirtuosoSchema=true;createAlgoSchema=true;deployConfigService=true;deployI18nService=true;deployTileService=true;deployMetaDataService=true;deployROIService=true;deployWSAService=true;deployUploadService=true;deployAlgoHer2=true;deployAlgoHer2Dualish=true;deployAlgoEr=true;deployAlgoPr=true;deployAlgoPdl=true;deployAlgoKI67=true;deployAlgoIVDPdl=true;deployAlgoIVDHer2Dualish=true;deployUpathRestApp=true;deployApiGateway=false;executeOnboardTenant=true;executeDeleteTestTenant=true;executeCloudwatchAlarms=true;
    options {
    	buildDiscarder logRotator(daysToKeepStr: '3', numToKeepStr: '3')
    }


"""Build periodically with parameters  in jenkins dashboard."""

	 triggers {
        // Daily build trigger
        parameterizedCron(env.BRANCH_NAME == 'upc2\0-pi2dev' ? '''
            00 16 * * 1,2,3,4,7 %  stackName=upc;env=sit;region=us-west-2;awsAccountId=489715691119;buildType=daily;buildLabel=;branchName=upc20-pi2dev;virtuosoBranchName=refs/heads/upc20-pi2dev;cloudwatchAlarmEmailIds=palanikumar.tangapandian@contractors.roche.com,kulpreet.saluja@contractors.roche.com,aniz_mohammed.nizar@contractors.roche.com,sathish.mugithe@contractors.roche.com;uPath-Cloud-rest-api=uPath-Cloud-rest-api;deleteStack=false;triggerBuildBeforeDeploy=true;deployCoreStack=true;deploySchemaMigratorLambda=true;deployTenantOnboardingLambda=true;createVirtuosoSchema=true;createAlgoSchema=true;deployConfigService=true;deployI18nService=true;deployTileService=true;deployMetaDataService=true;deployROIService=true;deployWSAService=true;deployUploadService=true;deployConnectInService=true;deployConnectOutService=true;deployAlgoHer2=true;deployAlgoHer2Dualish=true;deployAlgoEr=true;deployAlgoPr=true;deployAlgoPdl=true;deployAlgoKI67=true;deployAlgoIVDPdl=true;deployAlgoIVDHer2Dualish=true;deployAlgoIVDHer2=true;deployUpathRestApp=true;deployApiGateway=false;executeOnboardTenant=true;executeDeleteTestTenant=true;executeCloudwatchAlarms=true;parallelizeDeleteStackAndBuild=true;upathKeyPairName=upc-sit-keypair;msNamespace=microservices;redisNamespace=redis;version='1.4';deployFrontend=true;frontendBranchName=upc20-pi2dev ''' :
			'')

//"""Anyway environment variables are not currently accessible directly as Groovy variables in Pipeline (there is a proposal to allow it); you need to use the env global variable:

def branch = env.BRANCH_NAME"""


    }

    parameters {
        // Common Param inputs used across all deployments
        string(name: 'stackName', defaultValue: 'upc', description: 'The Stack to which code will be deployed.')
		 string(name: 'stackNameToDelete', defaultValue: 'upc1', description: 'The Stack which needs to be deleted.')
        string(name: "env", defaultValue: 'dev', description: 'env name')
        string(name: 'region', defaultValue: 'us-west-2', description: 'AWS Region')
        string(name: 'awsAccountId', defaultValue: '943150447085', description: "int account:064790629266, dev account:943150447085, qa account:595570980330")
        choice(name: 'buildType', choices:['sprint', 'daily', 'manual'], description: "Specifies build type to use")
        string(name: 'buildLabel', defaultValue: '', description: ' Build Label to use')
        string(name: 'branchName', defaultValue: 'upc14-st2dev', description: ' Branch to use')
		string(name: 'version', description: 'Version no. for the build ex. 1.4st1,1.4st2,1.4')
        string(name: 'msNamespace', defaultValue: 'microservices',description: 'Namespace where microservices are present')
        string(name: 'uPathNamespace', defaultValue: 'uPath Namespace',description: 'Namespace where upath is deployed')
        string(name: 'redisNamespace', defaultValue: 'redis',description: 'Namespace where redis is running')
        string(name: 'virtuosoBranchName', defaultValue: 'refs/heads/upc14-st2dev', description: 'Virtuoso branch name')
		string(name: 'frontendBranchName', defaultValue: 'upc14-st2dev', description: ' Frontend branch name')
        string(name: 'upathKeyPairName', defaultValue: 'upc1-dev-jenkins', description: 'Virtuoso branch name')
        string(name: 'tenantAlias', defaultValue: 'dailyTestTenant', description: 'tenant alias')
        string(name: 'onboardTenantUUID', defaultValue: '')
        string(name: 'cloudwatchAlarmEmailIds', defaultValue: '')
        string(name: 'apiGatewayName', defaultValue: 'uPath-Cloud-rest-api')
        string(name: "authorizerURI", defaultValue:"arn:aws:lambda:us-west-2:468280580845:function:appdevus-product-authorizer",  description: 'Navify Authorizer URI lamba ARN')
		string(name: "devaccountAmiId", defaultValue: 'ami-01286da360c441340', description: 'Windows Latest platform hardened AMI from Dev Account for Algorithms, IOT, ROI..etc')
	    string(name: "algoBranchName", defaultValue: 'upc14-st2dev', description: 'RUO algorithm branch name')
	    string(name: 'amiID', defaultValue: 'ami-0865e3a43448ee2c4', description: 'Linux EKS Latest platform hardened AMI from respective AWS Account for EKS-Cluster creation')
        string(name: 'SMTPSecretUsername', defaultValue: '', description: 'Enter the SMTP user for the secrete name "/upath-{Environment}/${StackName}/infra/smtp/username"')
		password(name: 'SMTPSecretPassword', defaultValue: '', description: 'Enter the SMTP user for the secrete password "/upath-{Environment}/${StackName}/infra/smtp/password"')
        string(name: 'AWSAccountIDstoShareECRRepository', defaultValue: "'arn:aws:iam::064790629266:root','arn:aws:iam::595570980330:root','arn:aws:iam::765911385762:root','arn:aws:iam::995841348831:root','arn:aws:iam::489715691119:root'", description: 'Enter the list of AWS account IDs in the given format to share the ECR Repository(Exclude Current AWS Account ID)')

        // Switches to turn on/off deployments
        booleanParam(name: 'deleteStack', defaultValue: false, description: "Perform Stack Deletion")
        booleanParam(name: 'triggerBuildBeforeDeploy', defaultValue: true, description: "Trigger build of all microservices and Upath")
        booleanParam(name: 'deployCoreStack', defaultValue: true, description: "Deploy Core Stack")
        booleanParam(name: 'deploySchemaMigratorLambda', defaultValue: true, description: "Deploy Schema Migrator Lambda")
        booleanParam(name: 'deployTenantOnboardingLambda', defaultValue: true, description: "Deploy Tenant Onboarding Lambda")
        booleanParam(name: 'createVirtuosoSchema', defaultValue: true, description: "Create Vituoso Schema")
        booleanParam(name: 'createAlgoSchema', defaultValue: true, description: "Create Algorithm Schema")
        booleanParam(name: 'deployConfigService', defaultValue: true, description: "Deploy Config Service")
        booleanParam(name: 'deployI18nService', defaultValue: true, description: "Deploy i18n Service")
        booleanParam(name: 'deployTileService', defaultValue: true, description: "Deploy Tile/IOT Service")
        booleanParam(name: 'deployMetaDataService', defaultValue: true, description: "Deploy Image Metadata Service")
        booleanParam(name: 'deployROIService', defaultValue: true, description: "Deploy ROI Service")
        booleanParam(name: 'deployWSAService', defaultValue: true, description: "Deploy WSA Service")
        booleanParam(name: 'deployUploadService', defaultValue: true, description: "Deploy Image Upload Service")
        booleanParam(name: 'deployImageDeletionService', defaultValue: true, description: "Deploy Image Deletion Service")
        booleanParam(name: 'deploySearchService', defaultValue: true, description: "Deploy Search Service")
        booleanParam(name: 'deployJobManagementService', defaultValue: true, description: "Deploy Job Management Service")
		booleanParam(name: 'deployConnectInService', defaultValue: true, description: "Deploy Connect In Service")
		booleanParam(name: 'deployConnectOutService', defaultValue: true, description: "Deploy Connect Out Service")
		booleanParam(name: 'deployRegistrationService', defaultValue: true, description: "Deploy Registration Service")
        booleanParam(name: 'deployAlgoHer2', defaultValue: true, description: "Deploy Her2 Algorithm Service")
        booleanParam(name: 'deployAlgoHer2Dualish', defaultValue: true, description: "Deploy Her2DualIsh Algorithm Service")
        booleanParam(name: 'deployAlgoHer2Dualish101', defaultValue: true, description: "Deploy Her2DualIsh 1.0.1 Algorithm Service")
        booleanParam(name: 'deployAlgoEr', defaultValue: true, description: "Deploy ER Algorithm Service")
        booleanParam(name: 'deployAlgoPr', defaultValue: true, description: "Deploy PR Algorithm Service")
        booleanParam(name: 'deployAlgoPdl', defaultValue: true, description: "Deploy PDL1 Algorithm Service")
        booleanParam(name: 'deployAlgoKI67', defaultValue: true, description: "Deploy KI67 Algorithm Service")
        booleanParam(name: 'deployAlgoIVDHer2Dualish', defaultValue: true, description: "Deploy IVD Her2DualIsh Algorithm Service")
        booleanParam(name: 'deployAlgoIVDHer2', defaultValue: true, description: "Deploy IVD Her2 Algorithm Service")
        booleanParam(name: 'deployAlgoIVDPdl', defaultValue: true, description: "Deploy IVD PDL1 Algorithm Service")
        booleanParam(name: 'deployUpathRestApp', defaultValue: true, description: "Deploy UPath Rest App Service")
        booleanParam(name: 'deployApiGateway', defaultValue: false, description: "Update API Gateway to VPC Link")

        booleanParam(name: 'executeOnboardTenant', defaultValue: true, description: "Onboard a Tenant ")
        booleanParam(name: 'executeDeleteTestTenant', defaultValue: true, description: "Delete a given Tenant")
		booleanParam(name: 'deployFrontend', defaultValue: true, description: "Deploy Frontend")
        booleanParam(name: 'executeCloudwatchAlarms', defaultValue: true, description: "Create cloud watch Alarms ")
        booleanParam(name: 'parallelizeDeleteStackAndBuild', defaultValue: false, description: "Parallelly execute Stack deletion and Code Build")
    }
    environment {
        AWS_ACCESS_KEY_ID = credentials("UPATH_${params.env.toUpperCase()}_AWS_ACCESS_KEY")
        AWS_SECRET_ACCESS_KEY = credentials("UPATH_${params.env.toUpperCase()}_AWS_ACCESS_SECRET")
        AWS_DEFAULT_REGION = "${params.region}"
        DOME9_USER = credentials("DOME9_USER_ID")
        DOME9_PASS = credentials("DOME9_SECRET_KEY")
    }

"""How jenkins find credentilas
To do that, just go to Jenkins - Manage Jenkins - Configure System - Global properties - Environment variables
"""

    stages {
        stage('Prepare Deploy to Stack') {
            steps {
                script {
                    dir('single-click-deployments')   """go to single click deployments folder""" {

						// Corestack params """get parametrs from files inside this directory"""


						coreStackJobParams = getCoreStackParamsFromFile(fileNameMap[params.env], params.stackName, params.upathKeyPairName, params.SMTPSecretUsername, params.SMTPSecretPassword.toString())
						onboardTenantParams = getOnboardTenantParamsFromFile(fileNameMap[params.env], params.stackName, params.region)
						frontendParams = getFrontendParamsFromFile(fileNameMap[params.env])

                    }

                    // Generate Build Label

                    if(params.buildType == 'manual' && (params.buildLabel == "" || params.buildLabel == null)){
                        error("Specify Build Label for manual build")
                    }

                    if(params.buildType != 'manual' && (params.buildLabel == "" || params.buildLabel == null)) {
                        dateAsNumber = new com.roche.upath.jenkins.Utils().getCurrentDateAs("yyyyMMddHHmm")
                        buildLabel = params.buildType != "manual" ? params.buildType+ "-" + dateAsNumber : params.buildLabel;
                    }else{
                        buildLabel = params.buildLabel;
                    }

                    echo "Build Label used is ${buildLabel}"


                    // Common Parameters
                    commonStackParams = [string(name: "stackName", value:params.stackName),
                                         string(name: "env", value:params.env),
                                         string(name: "region", value:params.region)]

                    deleteStackParams = [string(name: "stackName", value:params.stackNameToDelete),
                                         string(name: "env", value:params.env),
                                         string(name: "region", value:params.region),string(name:"apiGatewayName", value:params.apiGatewayName),
										 string(name:"deleteCoreStack", value: "true")
										]
                    wsGatewayParams = commonStackParams + [string(name:"authorizerURI", value:params.authorizerURI)]

                    //Microservices Param
                    microServicesJobParams = commonStackParams + [
                            string(name: "awsAccountId", value:params.awsAccountId),
                            string(name: "commitId", value:""),
                            string(name: "buildNumber", value:""),
                            string(name: "buildId", value:""),
                            string(name: "buildCommitId", value:""),
                            string(name: "buildLabel", value:buildLabel),
                            string(name: "amiId", value: ""),
                            booleanParam(name: "deployToStack", value: true),
							string(name: "version", value:params.version),
							string(name: "AWSAccountIDstoShareECRRepository", value: params.AWSAccountIDstoShareECRRepository)
                    ]

                    upathNamespaceParams = [
                            string(name: "msNamespace", value:params.msNamespace),
                            string(name: "redisNamespace", value:params.redisNamespace),
                            string(name: "uPathNamespace", value:params.uPathNamespace),

                    ]

                    buildJobParams = commonStackParams + [
                            string(name: "commitId", value:""),
                            string(name: "buildNumber", value:""),
                            string(name: "buildId", value:""),
                            string(name: "buildCommitId", value:""),
                            string(name: "buildLabel", value:buildLabel),
                            string(name: "amiId", value: ""),
                            booleanParam(name: "deployToStack", value: true),
                            string(name: "algoBranchName", value:params.branchName),
                            string(name: "upathdevopsBranchName", value:params.branchName),
                            string(name: "virtuosoBranchName", value:params.virtuosoBranchName),
							string(name: "version", value:params.version),
			                string(name: "devaccountAmiId", value: params.devaccountAmiId)
                    ]


                    // Onboard tenant Params
                    tenantUUIDParam = string(name:"TenantUUID", value:params.onboardTenantUUID)
                    deleteTenantUUIDParam = string(name:"TenantUUIDs", value:params.onboardTenantUUID)
                    tenantAlias = string(name:"TenantAlias", value: params.tenantAlias)

                    // Schema creation Params
                    def virtuosoBranchNameParam = string(name: "branchName", value:params.virtuosoBranchName);
                    def buildBranchNameParam = string(name: "branchName", value:params.branchName);

                    def performSchemaCreationParam = booleanParam(name: "performSchemaCreation", value:true);

                    def cloudwatchAlarmNotificationEmails = string(name: "emailIds", value:params.cloudwatchAlarmEmailIds);

					def her2DualIsh101AlgoIdParam = microServicesJobParams + [string(name: "algoId", value:"9005.1.0.1")];


                    //Define Deployment jobs

                    def servicesBuildJob = [
                        new com.roche.upath.jenkins.Deployment('build-all', '/upath-cloud-daily-build-multibranch-pipeline' + "/" + params.branchName, 'build', buildJobParams,  !params.triggerBuildBeforeDeploy, 1),

                        new com.roche.upath.jenkins.Deployment('core-stack', '/core-stack-deployment-multibranch-pipeline' + "/" + params.branchName, 'infra', coreStackJobParams, !params.deployCoreStack,2 ),
                        new com.roche.upath.jenkins.Deployment('eks-core-components', '/eks-core-components-multibranch-pipeline'  + "/" + params.branchName, 'infra', coreStackJobParams, !params.deployCoreStack,3 ),

                        new com.roche.upath.jenkins.Deployment('cloud-watch-dashboard-alarms', '/create-analysis-scheduler-alarm-multibranch-pipeline' + "/" + params.branchName, 'infra', microServicesJobParams + cloudwatchAlarmNotificationEmails, !params.executeCloudwatchAlarms, 4),

                        //Schema creator lambda

                        new com.roche.upath.jenkins.Deployment('schema-creator-lambda', '/upath-schema-creator-utils-deploy-multibranch-pipeline' + "/" + params.branchName, 'lambda', microServicesJobParams, !params.deploySchemaMigratorLambda, 4),
                        new com.roche.upath.jenkins.Deployment('algo-schema-creation', '/upc-algo-schema-creator-multibranch-pipeline/' + params.branchName, 'lambda', microServicesJobParams, !params.createAlgoSchema, 5),

                        //Deploy micro services stack
                        new com.roche.upath.jenkins.Deployment('config-service', '/upath-config-deployment-multibranch-pipeline' + "/" + params.branchName, 'docker', microServicesJobParams, !params.deployConfigService,6),
                        new com.roche.upath.jenkins.Deployment('i18-service', '/upath-i18-deployment-multibranch-pipeline' + "/" + params.branchName, 'docker', microServicesJobParams, !params.deployI18nService,7),
                        new com.roche.upath.jenkins.Deployment('onboarding-service-lambda', '/upath-onboarding-service-deployment-multibranch-pipeline' + "/" + params.branchName, 'lambda', microServicesJobParams,!params.deployTenantOnboardingLambda,7),

                        new com.roche.upath.jenkins.Deployment('image-tile-service', '/upath-iot-deploy-multibranch-pipeline' + "/" + params.branchName, 'ami', frontendParams + microServicesJobParams, !params.deployTileService, 7),
                        new com.roche.upath.jenkins.Deployment('image-metadata-service', '/upath-metadata-deploy-multibranch-pipeline' + "/" + params.branchName, 'docker', microServicesJobParams, !params.deployMetaDataService, 8),

                        new com.roche.upath.jenkins.Deployment('wsa-service', '/upath-wsa-deploy-multibranch-pipeline' + "/" + params.branchName, 'docker', microServicesJobParams, !params.deployWSAService, 9),
                        new com.roche.upath.jenkins.Deployment('image-roi-service', '/upath-roi-deploy-multibranch-pipeline' + "/" + params.branchName, 'ami', microServicesJobParams, !params.deployROIService, 8),

						new com.roche.upath.jenkins.Deployment('registration-service', '/dp-registration-service-deployment-multibranch-pipeline' + "/" + params.branchName, 'docker', microServicesJobParams, !params.deployRegistrationService, 8),

                        new com.roche.upath.jenkins.Deployment('image-upload-service', '/upath-imageupload-deploy-multibranch-pipeline' + "/" + params.branchName, 'docker', microServicesJobParams, !params.deployUploadService, 9),
                        // Deploy image deletion service
                        new com.roche.upath.jenkins.Deployment('image-deletion-service', '/dp-ms-imagedeletion-deploy-multibranch-pipeline' + "/" + params.branchName, 'docker', microServicesJobParams, !params.deployImageDeletionService, 9),
                        // Deploy search service
                        new com.roche.upath.jenkins.Deployment('search-service', '/dp-ms-search-deploy-multibranch-pipeline' + "/" + params.branchName, 'docker', microServicesJobParams, !params.deploySearchService, 9),
                        // Deploy Job Management service
                        new com.roche.upath.jenkins.Deployment('job-management-service', '/dp-ms-jobmanagement-deploy-multibranch-pipeline' + "/" + params.branchName, 'docker', microServicesJobParams, !params.deployJobManagementService, 9),

                        // Deploy UPath EAR
                        new com.roche.upath.jenkins.Deployment('upath-restapp-service',
                                '/dp-cloud-upath-deploy-mb-pipeline' + "/" + params.branchName,"docker",
                                microServicesJobParams + upathNamespaceParams,
                                !params.deployUpathRestApp, 10),

						new com.roche.upath.jenkins.Deployment('connect-in-service', '/dp-connectin-deploy-multibranch-pipeline' + "/" + params.branchName, 'docker', microServicesJobParams + upathNamespaceParams, !params.deployConnectInService, 11),
						new com.roche.upath.jenkins.Deployment('connect-out-service', '/dp-connectout-deploy-multibranch-pipeline' + "/" + params.branchName, 'docker', microServicesJobParams + upathNamespaceParams, !params.deployConnectOutService, 11),

                        //Deploy Algorithms
                        new com.roche.upath.jenkins.Deployment('algo-pdl-service',
                                '/upath-algo-pdl-deploy-multibranch-pipeline' + "/" + params.branchName, 'ami', microServicesJobParams, !params.deployAlgoPdl, 12),
                        new com.roche.upath.jenkins.Deployment('algo-er-service',
                                '/upath-algo-er-deploy-multibranch-pipeline' + "/" + params.branchName, 'ami', microServicesJobParams, !params.deployAlgoEr, 12),
                        new com.roche.upath.jenkins.Deployment('algo-pr-service',
                                '/upath-algo-pr-deploy-multibranch-pipeline' + "/" + params.branchName, 'ami', microServicesJobParams, !params.deployAlgoPr, 12),
                        new com.roche.upath.jenkins.Deployment('algo-ki67-service',
                                '/upath-algo-ki67-deploy-multibranch-pipeline' + "/" + params.branchName, 'ami', microServicesJobParams, !params.deployAlgoKI67, 12 ),
                        new com.roche.upath.jenkins.Deployment('algo-her2dualish-service',
                                '/upath-algo-her2dualish-deploy-multibranch-pipeline' + "/" + params.branchName, 'ami', microServicesJobParams, !params.deployAlgoHer2Dualish, 12),
                        new com.roche.upath.jenkins.Deployment('algo-her2dualish101-service',
                                '/upath-algo-her2dualish101-deploy-multibranch-pipeline' + "/" + params.branchName, 'ami', her2DualIsh101AlgoIdParam, !params.deployAlgoHer2Dualish101, 12),
                        new com.roche.upath.jenkins.Deployment('algo-her2-service',
                                '/upath-algo-her2-deploy-multibranch-pipeline' + "/" + params.branchName, 'ami', microServicesJobParams,!params.deployAlgoHer2, 12),
                        new com.roche.upath.jenkins.Deployment('algo-ivdpdl-service',
                                '/upath-algo-ivdpdl-deploy-multibranch-pipeline' + "/" + params.branchName, 'ami', microServicesJobParams, !params.deployAlgoIVDPdl, 12),
                        new com.roche.upath.jenkins.Deployment('algo-ivdher2dualish-service',
                                '/upath-algo-ivdher2dualish-deploy-multibranch-pipeline' + "/" + params.branchName, 'ami', microServicesJobParams, !params.deployAlgoIVDHer2Dualish, 12),
						new com.roche.upath.jenkins.Deployment('algo-ivdher2-service',
                                '/upath-algo-ivdher2-deploy-multibranch-pipeline' + "/" + params.branchName, 'ami', microServicesJobParams, !params.deployAlgoIVDHer2, 12),

						//Frontend
						new com.roche.upath.jenkins.Deployment( 'frontend-build-deploy', '/frontend-build-deployment-multibranch-pipeline' + "/" + params.frontendBranchName, "infra", frontendParams, !params.deployFrontend, 12),

						// Delete Tenant
						new com.roche.upath.jenkins.Deployment('delete-tenant-lambda', '/upath-delete-tenants-multibranch-pipeline/' + params.branchName, 'lambda', onboardTenantParams,  !params.executeDeleteTestTenant, 13),

                        // Onboard Tenant
                        new com.roche.upath.jenkins.Deployment('upath-onboard-tenant', '/Onboard-Tenant-multibranch-pipeline' + "/" + params.branchName, "lambda", onboardTenantParams, !params.executeOnboardTenant, 14),

						new com.roche.upath.jenkins.Deployment('delete-all-stacks', '/upc-stack-deletion-multibranch-pipeline' + "/" + params.branchName, 'infra', deleteStackParams, !params.deleteStack, params.parallelizeDeleteStackAndBuild ? 1 : 15 ),

                        // Update WS Gateway
                        new com.roche.upath.jenkins.Deployment('upath-wsgateway-create', '/upath-ws-gateway-multibranch-pipeline' + "/" + params.branchName, "infra", commonStackParams, !params.deployApiGateway, 16)


                    ]

                    // Group jobs by build order for parallelization
                    def groupedJobs = parallelDeployUtils.group(servicesBuildJob)

                    groupedJobs.each { group ->
                        dome9.elevateIAMPermission params.env, env.DOME9_USER, env.DOME9_PASS

                        //Perform Parallel Execution
                        parallel(parallelDeployUtils.getParallelExecution(group))
                    }



                    dome9.elevateIAMPermission params.env, env.DOME9_USER, env.DOME9_PASS
                    if( params.deployApiGateway)
                        apiGateway.updateApiGatewayToVPC params.env
                    if(params.deployUploadService)
                        route53.updateUploadServiceRecordSet params.env, params.stackName
                }
            }
        }
    }
}

def getCoreStackParamsFromFile(String envFileName, String stackName, String upathKeyPairName, String SMTPSecretUsername, String SMTPSecretPassword){
	def overrides = [:]
	overrides["StackName"] = stackName
	overrides["KeyPairName"] = upathKeyPairName
    overrides["SMTPSecretUsername"] = SMTPSecretUsername
    overrides["SMTPSecretPassword"] = SMTPSecretPassword
    return asJenkinsBuildParams (file: 'core-stack-params-' + envFileName + '.json', overrides:overrides)
}

def getOnboardTenantParams(String envFileName, String stackName, String region){
	def overrides = [:]
	overrides["stackName"] = stackName
    return  asJenkinsBuildParams (file: 'onboard-params-' + envFileName + '.json',overrides:overrides)

}

def getFrontendParamsFromFile(String envFileName){
    return asJenkinsBuildParams (file: 'frontend-params-' + envFileName + '.json')
}
