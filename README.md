Table of Contents
=================

   * [General Introduction](#General-Introduction)
   * [Contents of growingBugs](#Contents-of-growingBugs)
   * [Setting up](#Setting-up-GrowingBugs)
      * [Requirements](#Requirements)
      * [Steps to set up GrowingBugs](#Steps-to-set-up-GrowingBugs)
   * [Using GrowingBugs](#Using-GrowingBugs)
      * [Typical Usage](#Typical-Usage)  
      * [Docker Image](#Docker-Image)
      * [Versions](#Versions)
   * [Copyright](#Copyright)
   * [Citation](#Citation)
      
# General Introduction
This is a bug repository that keeps growing, called ***growingBugs***

Notably, each bug in ***growingBugs*** is composed of a buggy version, a fixed version, a ***concise patch*** (bug-fixing changes only), and one or more triggering test cases.



# Contents of growingBugs

To date, growingBugs contains **`1905`** real-world bugs from open-source Java projects. 

|   | Project ID      | Project name               |   SubProject locator             |Number of bugs | Bug IDs      | 
|-----------------|-----------------|----------------------------|--------------------------------|-------------:|-------------------|
| 1     | Chart           | jfreechart                 |                           |       26       | 1-26                |
| 2     | Cli             | commons-cli                |                           |       41       | 1-5,7-42            |
| 3     | Closure         | closure-compiler           |                           |      174       | 1-62,64-92,94-176   |
| 4     | Codec           | commons-codec              |                           |       19       | 1-19                |
| 5     | Collections     | commons-collections        |                           |        8       | 25-31,35               |
| 6     | Compress        | commons-compress           |                           |       51       | 1-48,50,52-53       |
| 7     | Csv             | commons-csv                |                           |       17       | 1-17                |
| 8     | Gson            | gson                       |         gson              |       25       | 1-25                |
| 9     | JacksonCore     | jackson-core               |                           |       30       | 1-26,28-31                |
| 10     | JacksonDatabind | jackson-databind           |                          |      150       | 1-85,87-112,121-126,</br>128-129,131-133,135-156               |
| 11     | JacksonXml      | jackson-dataformat-xml     |                          |        6       | 1-6                 |
| 12    | Jsoup           | jsoup                      |                           |       93       | 1-93                |
| 13     | JxPath          | commons-jxpath             |                          |       22       | 1-22                |
| 14     | Lang            | commons-lang               |                          |       72       | 1,3-33,35-65,69,71,73,</br>76,80-84              |
| 15     | Math_4j            | commons-math4j               |                          |      106       | 1-106               |
| 16     | Mockito         | mockito                    |                          |       38       | 1-38                |
| 17     | Time            | joda-time                  |                          |       26       | 1-20,22-27          |
| 18     | Dbutils         | commons-dbutils            |                          |        2       | 1-2                 |
| 19     | Functor         | commons-functor            |                          |        2       | 1-2                 |
| 20     | Imaging         | commons-imaging            |                          |        10      | 1,3-8,10-11,14  |
| 21     | IO              | commons-io                 |                          |        22       | 1-3,5-6,8-18,</br>22,25,27,29-31                |
| 22     | JXR             | maven-jxr                  |                          |        1       | 1                   |
| 23     | MShade          | maven-shade-plugin         |                          |        6       | 1-4,6-7                 |
| 24     | Tika            | tika                       |                          |        5       | 1-2,5-7               |
| 25     | Validator       | commons-validator          |                          |        21      | 1-2,4,6-9,11,</br>13-25 |
| 26     | Pool            | commons-pool               |                          |        17      | 1,5-7,10-14,</br>16,20-21,24,</br>26-27,29-30|
| 27     | Email           | commons-email              |                          |        3       | 3-5                 |
| 28     | Graph           | commons-graph              |                          |        5       | 1-5                 |
| 29     | Net             | commons-net                |                          |        14      | 9,10,12,</br>14-18,20-21,</br>23-26             |
| 30     | Numbers_angle   | commons-numbers-angle            |  commons-numbers-angle         |        2       | 1-2               |
| 31     | Geometry_core   | geometry-core           |    commons-geometry-core |        2       | 1,3               |
| 32     | MGpg            | maven-gpg-plugin           ||        1       | 1               |
| 33     | Text            | commons-text               ||        4       | 1-2,4-5               |
| 34     | Tika_core            | tika-core               |  tika-core |        23       | 4,6,9,11,</br>17,20-25,28-39               |
| 35     | Tika_app            | tika-app               |   tika-app     |        2       | 1,3               |
| 36     | Shiro_core            | shiro-core               |      core      |        10       | 37,40,46,52,98,</br>144,176,181,202-203               |
| 37     | Jena_core            | jena-core               |    jena-core   |        1       | 2               |
| 38     | Shiro_web            | shiro-web               |        web      |        8       | 1,3,7-12               |
| 39     | MDeploy            | maven-deploy-plugin               |              |        1       | 1               |
| 40     | Jackrabbit_filevault<br/>_vault_validation | jackrabbit-filevault-vault-validation               |       vault-validation       |        4       | 1-4               |
| 41     | Jackrabbit_oak_core            | oak-core               |       oak-core       |        5       | 1-5               |
| 42     | Doxia_module_apt            | doxia-module-apt               |   doxia-modules/doxia-module-apt       |       2       | 1-2               |
| 43     | Rdf_jena            | commons-rdf-jena               |       commons-rdf-jena       |        1       | 1               |
| 44     | Maven_checkstyle_plugin            | maven-checkstyle-plugin               |             |        1       | 1               |
| 45     | James_project_core            | james-project-core               |       core       |        2       | 1-2               |
| 46     | Pdfbox_fontbox            | pdfbox-fontbox      |       fontbox      |        7       | 1-7               |
| 47     | AaltoXml            | aalto-xml      |             |        8       | 1-5,7-9               |
| 48     | HttpClient5            | httpclient5      |       httpclient5      |        7       | 1-2,4-8               |
| 49     | jackson_modules<br/>_java8_datetime      | jackson-modules-java8-datetime |      datetime  |        5       | 1-5               |
| 50     | Pdfbox_pdfbox         | pdfbox-pdfbox |    pdfbox    |        3      | 1-3               |
| 51     | Storm_client            | storm-client      |       storm-client      |        1       | 1              |
| 52     | James_mime4j_core            | James-mime4j-core |      core   |       9     | 1-9              |
| 53     | JacksonDataformatsText<br/>_yaml            | jackson-dataformats-text-yaml |      yaml   |       6     | 1-2,4-7              |
| 54     | JacksonDataformatsText<br/>_properties            | jackson-dataformats-text-properties |      properties   |       2     | 1-2              |
| 55     | JacksonDataformatBinary<br/>_avro            | jackson-dataformats-binary-avro |      avro   |       2     | 1-2              |
| 56     | JacksonDataformatBinary<br/>_cbor            | jackson-dataformats-binary-cbor |      cbor   |       5     | 1-5              |
| 57     | JavaClassmate            | java-classmate |        |       2     | 1-2              |
| 58     | JacksonModuleJsonSchema            | jackson-module-jsonSchema |      |       1     | 1              |
| 59     | JacksonDatatypeJoda            | jackson-datatype-joda |        |       2     | 2-3              |
| 60     | Bcel            | commons-bcel |        |       6     | 1-6              |
| 61     | JacksonDataformatBinary<br/>_protobuf            | jackson-dataformats-binary-protobuf |      protobuf   |       4     | 1-4              |
| 62     | Jackrabbit_filevault<br/>_vault_core            | jackrabbit-filevault-vault-core |      vault-core   |       1     | 1              |
| 63     | JacksonDatatypeJsr310            | jackson-datatype-jsr310 |         |       4     | 1-4              |
| 64     | JacksonDataformatBinary<br/>_smile            | jackson-dataformats-binary-smile |    smile     |       3     | 1-3              |
| 65     | JacksonModuleAfterburner            | jackson-module-afterburner |         |       3     | 1-3              |
| 66     | Woodstox            | woodstox |         |       7     | 1-7              |
| 67     | MetaModel_core            | MetaModel-core | core        |       9     | 1-9              |
| 68     | MetaModel_csv            | MetaModel-csv |  csv       |       1     | 1              |
| 69     | MetaModel_excel            | MetaModel-excel |  excel        |       1     | 1              |
| 70     | MetaModel_jdbc            | MetaModel-jdbc |  jdbc       |       3     | 1-3              |
| 71     | MetaModel_pojo            | MetaModel-pojo |  pojo       |       1     | 1              |
| 72     | MetaModel_salesforce            | MetaModel-salesforce |   salesforce      |       1     | 1              |
| 73     | Wink_common            | wink-common |  wink-common       |       4     | 1-4              |
| 74     | Xbean_naming            | xbean-naming |  xbean-naming       |       1     | 1              |
| 75     | James_project_<br/>server_container_core            | james-project-server-container-core |  server/container/core       |       1     | 1              |
| 76     | Johnzon_core            | johnzon-core |  johnzon-core       |       11     | 1-2,4-12              |
| 77     | Nifi_mock            | nifi-mock |  nifi-mock       |       2     | 1-2              |
| 78     | Rat_core            | apache-rat-core |  apache-rat-core       |       1     | 1              |
| 79     | Rat_plugin            | apache-rat-plugin |  apache-rat-plugin       |       1     | 1              |
| 80     | Tez_common            | tez-common |  tez-common       |       1     | 1              |
| 81     | Tinkerpop_gremlin_core            | gremlin-core |  gremlin-core       |       1     | 1              |
| 82     | Webbeans_web            | webbeans-web |  webbeans-web       |       1     | 1              |
| 83     | Hono_client            | hono-client |  client       |       4     | 1-4              |
| 84     | Httpcomponents_core_h2            | httpcore5-h2 |  httpcore5-h2       |       1     | 1              |
| 85     | Httpcomponents_core<br/>_httpcore5            | httpcore5 |  httpcore5       |       3     | 1-3              |
| 86     | Johnzon_jsonb            | johnzon-jsonb |  johnzon-jsonb       |       6     | 1-6              |
| 87     | Johnzon_jaxrs            | johnzon-jaxrs |  johnzon-jaxrs       |       1     | 1              |
| 88     | Hbase_common      | hbase-common |  hbase-common       |       1     | 1              |
| 89     | Incubator_tamaya_api            | incubator-retired-tamaya-api |  code/api       |       2     | 1-2              |
| 90     | James_project_<br/>mailet_standard            | james-project-mailet-standard |  mailet/standard       |       1     | 1              |
| 91     | Johnzon_jsonschema            | johnzon-jsonschema |  johnzon-jsonschema       |       2     | 1-2              |
| 92     | Johnzon_mapper            | johnzon-mapper |  johnzon-mapper       |       6     | 1-6              |
| 93     | Karaf_main            | karaf-main |  main       |       1     | 1              |
| 94     | Appformer_uberfire_<br/>commons_editor_backend            | uberfire-commons-editor-backend |  uberfire-extensions/uberfire-commons-editor/uberfire-commons-editor-backend       |       1     | 1              |
| 95     | Kie_pmml_commons            | kie-pmml-commons |  kie-pmml-trusty/kie-pmml-commons       |       3     | 1-3              |
| 96     | Kie_memory_compiler            | kie-memory-compiler |  kie-memory-compiler       |       1     | 1              |
| 97     | Jbpm_human<br/>_task_workitems            | jbpm-human-task-workitems |  jbpm-human-task/jbpm-human-task-workitems       |       1     | 1              |
| 98     | Drools_traits            | drools-traits |  drools-traits       |       1     | 1              |
| 99     | Drools_model_compiler            | drools-model-compiler |  drools-model/drools-model-compiler       |       1     | 1              |
| 100     | Appformer_uberfire<br/>_security_management</br>_client            | uberfire-security-management-client | uberfire-extensions/uberfire-security/uberfire-security-management/uberfire-security-management-client  |       1     | 1              |
| 101     | Appformer_uberfire<br/>_workbench_client            | uberfire-workbench-client |  uberfire-workbench/uberfire-workbench-client       |       3     | 1-3              |
| 102     | Deltaspike_api            | deltaspike-core-api |  deltaspike/core/api       |       6     | 1-6              |
| 103     | Flume_ngcore            | flume-ng-core |  flume-ng-core       |       2     | 1-2              |
| 104     | Jandex            | jandex |         |       6     | 1-6              |
| 105     | Kogito_editors<br/>_java_kie_wb_common</br>_stunner_widgets            | kie-wb-common-stunner-widgets |  kie-wb-common-stunner/kie-wb-common-stunner-client/kie-wb-common-stunner-widgets       |       1     | 1              |
| 106     | Ognl            | commons-ognl |         |       1     | 1              |
| 107     | Qpid_client            | qpid-jms-client |  qpid-jms-client       |       8     | 1-8              |
| 108     | Switchyard_admin            | switchyard-admin |  admin       |       1     | 1              |
| 109     | Weld_se_core            | weld-se-core |  environments/se/core       |       1     | 1              |
| 110     | Jboss_modules            | jboss-modules |        |       5     | 1,3-6              |
| 111     | Jboss_threads            | jboss-threads |        |       1     | 1              |
| 112     | Minaftp_api            | ftpserver-api |  ftplet-api       |       1     | 1              |
| 113     | Sling_validation            | sling-org-apache-sling-validation-core |       |       1     | 1              |
| 114     | Switchyard_config            | switchyard-config |  config       |       1     | 1              |
| 115     | Switchyard_validate            | switchyard-validate |  validate       |       1     | 1              |
| 116     | Wildfly_naming_client            | wildfly-naming-client |     |       2     | 1-2              |
| 117     | Dosgi_common            | dosgi-common | common    |       2     | 1-2              |
| 118     | Fluo_api            | fluo-api | modules/api     |       2     | 1,3              |
| 119     | Hivemall_core            | core |  core   |       3     | 1-3              |
| 120     | Knox_assertion_common            | gateway-provider-</br>identity-assertion</br>-common |  gateway-provider-</br>identity-assertion</br>-common     |       1     | 1              |
| 121     | Oozie_client            | oozie-client | client |       2     | 1-2              |
| 122     | Qpidjms_client            | qpidjms-client | client  |       3     | 1-3              |
| 123     | Rdf4j_query            | rdf4j-query | core/query    |       1     | 1              |
| 124     | Rdf4j_rio_api            | rdf4j-rio-api | core/rio/api  |       2     | 1-2              |
| 125     | Rdf4j_rio_jsonld            | rdf4j-rio-jsonld | core/rio/jsonld  |       2     | 1-2              |
| 126     | Rdf4j_rio_rdfjson            | rdf4j-rio-rdfjson | core/rio/rdfjson |       2     | 1-2              |
| 127     | Rdf4j_rio_rdfxml            | rdf4j-rio-rdfxml | core/rio/rdfxml    |       1     | 1              |
| 128     | Rdf4j_rio_turtle            | rdf4j-rio-turtle | core/rio/turtle    |       8    | 1-4,6,8-10              |
| 129     | Sentry_ccommon            | sentry-core-common |  sentry-core/sentry-core-common   |       2     | 1-2              |
| 130     | Sling_apiregions            | sling-apiregions |     |       3     | 1-3              |
| 131     | Sling_cpconverter            | sling-cpconverter |     |       3     | 1-3              |
| 132     | Tiles_api            | tiles-api | tiles-api    |       2     | 1-2              |
| 133     | Tiles_core            | tiles-core |  tiles-core   |       3     | 1-3              |
| 134     | Twill_dcore            | twill-discovery-core |  twill-discovery-core   |       1     | 1              |
| 135     | Maven2_artifact            | maven-artifact |  maven-artifact   |       2     | 1-2              |
| 136     | Maven2_project            | maven-project |  maven-project   |       2     | 1-2              |
| 137     | Math            | commons-math               |                          |      35       | 1-35               |
| 138     | Wicket_request            | wicket-request               |     wicket-request                     |      6       | 1-6               |
| 139     | Cayenne_xmpp            | cayenne-xmpp               |    cayenne-xmpp                      |      1       | 1               |
| 140     | Wicket_util            | wicket-util               |     wicket-util                     |     4       | 1-4               |
| 141     | Wicket_spring            | wicket-spring               |        wicket-spring                  |      1       | 1               |
| 142     | Cayenne_jgroups            | cayenne-jgroups               |    cayenne-jgroups                      |      1       | 1               |
| 143     | Cayenne_jms            | cayenne-jms               |     cayenne-jms                     |      1       | 1               |
| 144     | Struts1_core            | struts1-core               |     core                     |      2       | 1-2               |
| 145     | Wicket_cdi            | wicket-cdi               |     wicket-cdi                     |      1       | 1               |
| 146     | Wicket_core            | wicket-core               |     wicket-core                     |      18       | 1-18               |
| 147     | Mshared_archiver            | maven-archiver               |     maven-archiver                     |      1       | 1               |
| 148     | Shindig_common            | shindig-common               |     java/common                     |      1       | 1               |
| 149     | Xbean_reflect            | xbean-reflect               |     xbean-reflect                     |      1       | 1               |
| 150     | Mrunit            | mrunit               |                          |      2       | 1-2               |
| 151     | Rave_core            | rave-core               |          rave-components/rave-core         |      2       | 1-2               |
| 152     | Rave_commons            | rave-commons               |          rave-components/rave-commons         |      1       | 1               |
| 153     | Rave_web            | rave-web               |          rave-components/rave-web         |      1       | 1               |
| 154     | Jmh_core            | jmh-core               |          jmh-core         |      1       | 1               |
| 155     | Sdk_core            | sdk-core               |                   |      3       | 1-3               |
| 156     | Cargo_container            | cargo-container               |          core/api/container         |      4       | 1-4               |
| 157     | Oak_commons            | oak-commons               |          oak-commons         |      1       | 1               |
| 158     | Streamex            | streamex               |                   |      7       | 1-7               |
| 159     | Javapoet            | javapoet               |                   |      17       | 1-17               |
| 160     | RTree            | rtree               |                   |      12       | 1-12               |
| 161     | Spoon            | spoon               |                   |      17       | 1-17               |
| 162     | Canvas_api            | canvas-api               |                 |      4       | 1-4               |
| 163     | Coveralls_maven_plugin            | coveralls-maven-plugin               |                  |      8       | 1-8               |
| 164     | Slack_java_webhook            | slack-java-webhook               |                 |      1       | 1               |
| 165     | Zip4j            | zip4j               |                  |      52       | 1-52               |
| 166     | Incubator_retired_pirk            | incubator-retired-pirk               |                  |      1       | 1               |
| 167     | Sparsebitset             | SparseBitSet                |                  |      2       | 1-2               |
| 168     | Assertj_assertions_generator            | assertj-assertions-generator               |                  |      7       | 1-7               |
| 169     | Config_magic            | config-magic               |                  |      2       | 2               |
| 170     | Deft            | deft               |                  |      1       | 1               |
| 171     | Jcodemodel            | jcodemodel               |                  |      7       | 1-7               |
| 172     | Jdbm3            | JDBM3               |                  |      6       | 1-6               |
| 173     | Mybatis_pagehelper            | Mybatis-PageHelper               |                  |      4       | 1-4               |
| 174     | N5            | n5               |                  |      2       | 1-2               |
| 175     | Stash_jenkins_postreceive_webhook            | stash-jenkins-postreceive-webhook               |                  |      1       | 1               |
| 176     | Suffixtree            | suffixtree               |                  |      1       | 1               |
| 177     | Template_benchmark            | template-benchmark               |                  |      1       | 1               |
| 178     | Vectorz            | vectorz               |                  |      6       | 1-6               |
| 179     | Cli_parser         | cli-parser            |                  |      1       | 1                  |                 |
| 180     | Gatling_report         | gatling-report            |                  |      3       | 1-3                  |                 |
| 181     | Ber_tlv         | ber-tlv            |                  |      4       | 1-4                  |                 |
| 182     | Commons_suncalc         | commons-suncalc            |                  |      2       | 1-2                  |                 |
| 183     | Dropwizard_spring         | dropwizard-spring            |                  |      1       | 1                  |                 |
| 184     | Semux_core         | semux-core            |                  |      1       | 3                  |                 |
| 185     | Solarpositioning         | solarpositioning            |                  |      3       | 1-3                  |                 |
| 186     | Sparkey_java         | sparkey-java            |                  |      3       | 1-3                  |                 |
| 187     | Shazamcrest         | shazamcrest            |                  |      2       | 1-2                  |                 |
| 188     | Restfixture         | RestFixture            |                  |      4       | 1-4                  |                 |
| 189     | Chronicle_network         | Chronicle-Network            |                  |      4       | 1-4                  |                 |
| 190     | Farm         | farm            |                  |      4       | 1-4                  |                 |
| 191     | Gocd_slack_build_notifier         | gocd-slack-build-notifier            |                  |      3       | 1-3                  |                 |
| 192     | Confluence_http_authenticator         | confluence_http_authenticator            |                  |      1       | 1                  |                 |
| 193     | Tempus_fugit         | tempus-fugit            |                  |      1       | 1                  |                 |
| 194     | Kafka_graphite         | kafka-graphite           |                  |      1       | 1                  |                 |
| 195     | Simple_excel         | simple-excel           |                  |      1       | 1                  |                 |
| 196     | Trident_ml         | trident-ml           |                  |      1       | 1                  |                 |
| 197     | Tascalate_concurrent         | tascalate-concurrent           |                  |      2       | 1-2                  |                 |
| 198     | Jcabi_github         | jcabi-github           |                  |      81       | 1-42,44-82                  |
| 199     | Podam         | podam           |                  |      1       | 1                  |
| 200     | Sansorm         | SansOrm           |                  |      7       | 1-7                  |
| 201     | Transmittable_thread_local         | transmittable-thread-local           |                  |      4       | 1-4                  |
| 202     | Jchronic         | jchronic           |                  |      1       | 1                  |
| 203     | Netconf_java         | netconf-java           |                  |      1       | 1                  |
| 204     | Xades4j         | xades4j           |                  |      4       | 1-4                  |
| 205     | Spatial4j         | spatial4j           |                  |      4       | 1-4                  |
| 206     | Hive_funnel_udf         | hive-funnel-udf           |                  |      1       | 1                  |
| 207     | Iciql         | iciql           |                  |      2       | 1-2                  |
| 208     | Metrics_opentsdb         | metrics-opentsdb           |                  |      2       | 1-2                  |
| 209     | Hierarchical_clustering_java         | hierarchical-clustering-java           |                  |      1       | 1                  |
| 210     | Docker_java_api         | docker-java-api           |                  |      10       | 1-10                  |
| 211     | Github_release_plugin         | github-release-plugin           |                  |      2       | 1-2                  |
| 212     | Spring_context_support         | spring-context-support           |                  |      1       | 2                  |
| 213     | Jmimemagic         | jmimemagic           |                  |      1       | 1                  |
| 214     | Markedj         | markedj           |                  |      17       | 1-17                  |
| 215     | Sonartsplugin         | SonarTsPlugin           |                  |      10       | 1-10                  |
| 216     | Aws_maven         | aws-maven           |                  |      1       | 1                  |
| 217     | Snomed_owl_toolkit         | snomed-owl-toolkit           |                  |      2       | 1-2                  |
| 218     | Weak_lock_free         | weak-lock-free           |                  |      1       | 1                  |
| 219     | Proj4J         | proj4j           |                  |      9       | 1-9                  |
| 220     | Markedj         | markedj           |                  |      2       | 1-2                  |
| 221     | Rocketmq_mqtt_ds         | rocketmq-mqtt-ds           |       mqtt-ds           |      1       | 1                  |
| 222     | Retrofit         | retrofit           |       retrofit           |      3       | 1-3                  |
| 223     | Burst         | burst           |       burst           |      3       | 1-3                  |
| 224     | Jackrabbit_filevault_vault_validation        | jackrabbit-filevault-vault-validation          |       vault-validation           |      4       | 1-4                  |
| 225     | Jnagmp         | jnagmp           |       jnagmp           |      1       | 1                  |
| 226     | Rocketmq_mqtt_cs         | rocketmq-mqtt-cs           |       mqtt-cs           |      1       | 1   |
| 227     | Dagger_core         | dagger-core           |       core           |      20       | 1-20                  |
| 228     | Google_java_format_core         | google-java-format-core           |       core           |      1       | 1                  |
| 229     | Jimfs         | jimfs           |       jimfs           |      2       | 1-2                  |
| 230     | Open_location_code_java         | open-location-code-java           |       java           |      4       | 1-4                  |
| 231     | Gwtmockito         | gwtmockito           |       gwtmockito           |      3       | 1-3                  |
| 232     | Render_app         | render-app           |       render-app           |      5       | 1-5                  |
| 233     | Doubleclick_core         | openrtb-doubleclick-core           |       doubleclick-core           |      1       | 1                  |
| 234     | Tape         | tape           |         tape         |      13       | 1-13                  |
| 235     | Jcabi_http         | jcabi-http           |                  |      16       | 1-16                  |
| 236     | Jcabi_aether         | jcabi-aether           |                  |      1       | 1                  |
| 237     | Jcabi_w3c            | jcabi-w3c                       |                           |       1       | 1                |
| 238     | Jcabi_email            | jcabi-email                       |        |       4       | 1-4                |
| 239     | Jcabi_log            | jcabi-log                       |                        |       9       | 1-9                |
| 240     | Jcabi_matchers            | jcabi-matchers                       |                        |       2       | 1-2                |
| 241     | Jfreechart_fse            | jfreechart-fse                       |                        |       2       | 1-2                |
| 242     | Jfreesvg            | jfreesvg                       |                        |       1       | 1                |
| 243     | Leshan_core         | leshan-core           |       leshan-core      |      10       | 1-10                  |    
| 244     | Geo         | geo           |       geo        |      3       | 1-3                  |                 |
| 245     | Jackson_annotations         | jackson-annotations           |               |      1       | 1                  |
| 246     | Jackson_datatype_hibernate4         | jackson-datatype-hibernate4           |   hibernate4   |      1       | 1                  |
| 247     | Rtree2         | rtree2           |         |      6       | 1-6                |              
| 248     | Hilbert_curve         | hilbert-curve           |         |      3       | 1-3                |
| 249     | Subethasmtp         | subethasmtp           |         |      1       | 1                |

# Setting up GrowingBugs

## Requirements
 - Java 1.8
 - Git >= 1.9
 - SVN >= 1.8
 - Perl >= 5.0.12
 - Curl
 
## Steps to set up GrowingBugs
1. Clone GrowingBugs:
    - `git clone https://github.com/liuhuigmail/GrowingBugRepository.git`

2. Initialize GrowingBugs:

    Download the project repositories and external libraries that are not included in the git repository for size purposes and to avoid redundancies. We provide a mechanism to download them automatically as follows:
    
    - `cd GrowingBugRepository`
    - `cpanm --installdeps .`
    - `./init.sh`
    - `./repos.sh`
    
3. Add GrowingBugs's executables to your PATH:
    - `export PATH=$PATH:"path2growingbugs"/framework/bin`

# Using GrowingBugs

## Typical Usage
1. Checkout a buggy source code version (If the project doesn't hava subproject, `-s` parameter can be ignored):
    - `defects4j checkout -p project_id -v version_id -w work_dir -s subproject_locator` 
    
    Example:
  
    - `defects4j checkout -p Shiro_core -v 37b -w /tmp/Shiro_core_37_buggy -s core`
    - `defects4j checkout -p Dbutils -v 1b -w /tmp/dbutils_1_buggy`

   Notably, **GrowingBugs**  supports sub-projects that are not suported by Defects4J. To this end, yor should specify the sub-project with  `-s` parameter in the `checkout`  command. The preceding example common leverages `-s core` to check out sub-proejct `core` from the enclosing project `Shiro_core`. For the `compile` and `test` commands, you should also switch to the sub-project's folder to compile and test the sub-project.

2. Change to the working directory, compile sources and tests, and run tests:

   - `cd work_dir/subproject_locator`
   - `defects4j compile`
   - `defects4j test`
   
   Example1：
   
   - `cd /tmp/Shiro_core_37_buggy/core`
   - `defects4j compile`
   - `defects4j test`

   Example2：
   
   - `cd /tmp/dbutils_1_buggy`
   - `defects4j compile`
   - `defects4j test`

Currently, we resuse all APIs of **Defects4J** (more details at  https://github.com/rjust/defects4j), and thus all applications relying on **Defects4J** could be transferred smoothly to **GrowingBugs**. 

## Docker Image
To free users (especially beginers) of the repository from the complex configuration of the environments, we create and publish a Docker image of the system. You may download it by the following command:

- `docker pull registry.cn-hangzhou.aliyuncs.com/bit-zhuzhihao/growingbugrepository:0.3`

By simply loading the image with Docker, you can make the system ready for evaluation where all configurations (e.g., Java versions, paths, and even all data within the repository) should have been well set.  


## Versions
Because the bug repository keeps growing, let us known if you need a stable version for your study (e.g., evalutions for a research paper), and we will release a specific version where the bugs and patches are fixed (to faciliate the replication of your study).  

# Copyright
Notably, this bug repository is based on the well-known **Defects4J** https://github.com/rjust/defects4j. We reuse its source code as well as the bugs in **Defects4J**. The key difference is that **growingBugs** levearages **BugBuilder**[1] to exclude bug-irrelevarange changes from bug-fixing commmits automatically whereas **Defects4J** requests human experts to accomplish the same task. Consequently, **growingBugs** can keep growing automatically even ***without human intervention***.  

# Citation
If you are exploiting our dataset, please kindly cite the following paper:

**[1] Yanjie Jiang, [Hui Liu*](https://liuhuigmail.github.io/), Nan Niu, Lu Zhang, Yamin Hu. [Extracting Concise Bug-Fixing Patches from Human-Written Patches in Version Control Systems](https://ieeexplore.ieee.org/abstract/document/9401985). The 43rd International Conference on Software Engineering (ICSE), pp. 686-698, May, 2021**

**[2]Yanjie Jiang, [Hui Liu*](https://liuhuigmail.github.io/), Xiaoqing Luo, Zhihao Zhu, Xiaye Chi, Nan Niu, Yuxia Zhang, Yamin Hu, Pan Bian, and Lu Zhang. " [BugBuilder: An Automated Approach to Building Bug Repository](https://ieeexplore.ieee.org/document/9782533)," in IEEE Transactions on Software Engineering, Online 2022, doi: 10.1109/TSE.2022.3177713**

**[3]Yanjie Jiang, [Hui Liu*](https://liuhuigmail.github.io/),Yuxia Zhang, Weixing Ji, Hao Zhong, and Lu Zhang. "Do Bugs Lead to Unnaturalness of Source Code?" In Proceedings of the 30th ACM Joint European Software Engineering Conference and Symposium on the Foundations of Software Engineering (ESEC/FSE 2022). Association for Computing Machinery, New York, NY, USA, 1085–1096. https://doi.org/10.1145/3540250.3549149**

`@INPROCEEDINGS {GrowingBugsICSE21,
author = {Yanjie Jiang and Hui Liu and Nan Niu and Lu Zhang and Yamin Hu},
booktitle = {IEEE/ACM 43rd International Conference on Software Engineering (ICSE 2021)},
title = {Extracting Concise Bug-Fixing Patches from Human-Written Patches in Version Control Systems},
year = {2021},
pages = {686-698},
doi = {10.1109/ICSE43902.2021.00069},
url = {https://doi.ieeecomputersociety.org/10.1109/ICSE43902.2021.00069},
publisher = {IEEE Computer Society},
address = {Los Alamitos, CA, USA},
month = {may}
}`

`@ARTICLE{GrowingBugsTSE2022,  
author={Jiang, Yanjie and Liu, Hui and Luo, Xiaoqing and Zhu, Zhihao and Chi, Xiaye and Niu, Nan and Zhang, Yuxia and Hu, Yamin and Bian, Pan and Zhang, Lu},  
journal={IEEE Transactions on Software Engineering},   
title={BugBuilder: An Automated Approach to Building Bug Repository},   
year={2022},  
volume={},  
number={},  
pages={1-22},  
doi={10.1109/TSE.2022.3177713}}`

`@inproceedings{NaturalnessOfBugsFSE2022,
author = {Jiang, Yanjie and Liu, Hui and Zhang, Yuxia and Ji, Weixing and Zhong, Hao and Zhang, Lu},
title = {Do Bugs Lead to Unnaturalness of Source Code?},
year = {2022},
isbn = {9781450394130},
publisher = {Association for Computing Machinery},
address = {New York, NY, USA},
url = {https://doi.org/10.1145/3540250.3549149},
doi = {10.1145/3540250.3549149},
booktitle = {Proceedings of the 30th ACM Joint European Software Engineering Conference and Symposium on the Foundations of Software Engineering},
pages = {1085–1096},
numpages = {12},
keywords = {Naturalness, Source Code, Bug Fixing, Bugs, Code Entropy},
location = {Singapore, Singapore},
series = {ESEC/FSE 2022}
}`
