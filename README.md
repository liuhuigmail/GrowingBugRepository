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

To date, growingBugs contains **`1911`** real-world bugs from open-source Java projects. 

|   | Project ID      | Project name               |   SubProject locator             |Number of bugs | Bug IDs      | 
|-----------------|-----------------|----------------------------|--------------------------------|-------------:|-------------------|
| 1     | AaltoXml            | aalto-xml      |             |        8       | 1-5,7-9               |
| 2     | Bcel            | commons-bcel |        |       6     | 1-6              |
| 3     | Ber_tlv         | ber-tlv            |                  |      4       | 1-4                  |                 |
| 4     | Burst         | burst           |       burst           |      3       | 1-3                  |
| 5     | Canvas_api            | canvas-api               |                 |      4       | 1-4               |
| 6     | Chart           | jfreechart                 |                           |       26       | 1-26                |
| 7     | Cli             | commons-cli                |                           |       41       | 1-5,7-42            |
| 8     | Closure         | closure-compiler           |                           |      174       | 1-62,64-92,94-176   |
| 9     | Codec           | commons-codec              |                           |       19       | 1-19                |
| 10     | Collections     | commons-collections        |                           |        8       | 25-31,35               |
| 11     | Commons_suncalc         | commons-suncalc            |                  |      2       | 1-2                  |                 |
| 12     | Compress        | commons-compress           |                           |       51       | 1-48,50,52-53       |
| 13     | Coveralls_maven<br/>_plugin            | coveralls-maven<br/>-plugin               |                  |      8       | 1-8               |
| 14     | Csv             | commons-csv                |                           |       17       | 1-17                |
| 15     | Dbutils         | commons-dbutils            |                          |        2       | 1-2                 |
| 16     | Deltaspike_api            | deltaspike-core-api |  deltaspike<br/>/core/api       |       6     | 1-6              |
| 17     | Disklrucache         | DiskLruCache           |         |      6       | 1-6                |
| 18     | Docker_java_api         | docker-java-api           |                  |      10       | 1-10                  |
| 19     | Drools_model<br/>_compiler            | drools-model-compiler |  drools-model/<br/>drools-model-compiler       |       1     | 1              |
| 20     | Email           | commons-email              |                          |        3       | 3-5                 |
| 21     | Functor         | commons-functor            |                          |        2       | 1-2                 |
| 22     | Geo         | geo           |       geo        |      3       | 1-3                  |                 |
| 23     | Geometry_core   | geometry-core           |    commons-geometry-core |        2       | 1,3               |
| 24     | Github_release<br/>_plugin         | github-release-plugin           |                  |      2       | 1-2                  |
| 25     | Graph           | commons-graph              |                          |        5       | 1-5                 |
| 26     | Gson            | gson                       |         gson              |       25       | 1-25                |
| 27     | Hivemall_core            | core |  core   |       3     | 1-3              |
| 28     | IO              | commons-io                 |                          |        22       | 1-3,5-6,8-18,</br>22,25,27,29-31                |
| 29     | Imaging         | commons-imaging            |                          |        10      | 1,3-8,10-11,14  |
| 30     | Jackrabbit_<br/>filevault<br/>_vault_core            | jackrabbit-filevault-vault-core |      vault-core   |       1     | 1              |
| 31     | Jackrabbit_<br/>filevault_vault<br/>_validation        | jackrabbit-filevault-vault-validation          |       vault-validation           |      4       | 1-4                  |
| 32     | JacksonCore     | jackson-core               |                           |       30       | 1-26,28-31                |
| 33     | JacksonDatabind | jackson-databind           |                          |      150       | 1-85,87-112,121-126,</br>128-129,131-133,135-156               |
| 34     | JacksonDataformat<br/>Binary_cbor            | jackson-dataformats<br/>-binary-cbor |      cbor   |       5     | 1-5              |
| 35     | JacksonDataformat<br/>Binary_protobuf            | jackson-dataformats<br/>-binary-protobuf |      protobuf   |       4     | 1-4              |
| 36     | JacksonXml      | jackson-dataformat-xml     |                          |        6       | 1-6                 |
| 37     | James_mime4j<br/>_core            | James-mime4j-core |      core   |       9     | 1-9              |
| 38     | Lang            | commons-lang               |                          |       72       | 1,3-33,35-65,69,71,73,</br>76,80-84              |
| 39     | Math            | commons-math               |                          |      35       | 1-35               |
| 40     | Mockito         | mockito                    |                          |       38       | 1-38                |
| 41     | Shiro_web            | shiro-web               |        web      |        8       | 1,3,7-12               |
| 42     | Time            | joda-time                  |                          |       26       | 1-20,22-27          |
| 43     | Deft            | deft               |                  |      1       | 1               |
| 44     | Dosgi_common            | dosgi-common | common    |       2     | 1-2              |
| 45     | Doubleclick_core         | openrtb-doubleclick-core           |       doubleclick-core           |      1       | 1                  |
| 46     | Doxia_module_apt            | doxia-module-apt               |   doxia-modules/<br/>doxia-module-apt       |       2       | 1-2               |
| 47     | Drools_traits            | drools-traits |  drools-traits       |       1     | 1              |
| 48     | Dropwizard_spring         | dropwizard-spring            |                  |      1       | 1                  |                 |
| 49     | Farm         | farm            |                  |      4       | 1-4                  |                 |
| 50     | Flume_ngcore            | flume-ng-core |  flume-ng-core       |       2     | 1-2              |
| 51     | Fluo_api            | fluo-api | modules/api     |       2     | 1,3              |
| 52     | Hbase_common      | hbase-common |  hbase-common       |       1     | 1              |
| 53     | Hierarchical_<br/>clustering_java         | hierarchical-<br/>clustering-java           |                  |      1       | 1                  |
| 54     | Hilbert_curve         | hilbert-curve           |         |      3       | 1-3                |
| 55     | Hive_funnel_udf         | hive-funnel-udf           |                  |      1       | 1                  |
| 56     | Hono_client            | hono-client |  client       |       4     | 1-4              |
| 57     | Httpcomponents<br/>_core_h2            | httpcore5-h2 |  httpcore5-h2       |       1     | 1              |
| 58     | Httpcomponents<br/>_core_httpcore5            | httpcore5 |  httpcore5       |       3     | 1-3              |
| 59     | JXR             | maven-jxr                  |                          |        1       | 1                   |
| 60     | Jsoup           | jsoup                      |                           |       93       | 1-93                |
| 61     | JxPath          | commons-jxpath             |                          |       22       | 1-22                |
| 62     | Math_4j            | commons-math4j               |                          |      106       | 1-106               |
| 63     | MShade          | maven-shade-plugin         |                          |        6       | 1-4,6-7                 |
| 64     | Tika            | tika                       |                          |        5       | 1-2,5-7               |
| 65     | Validator       | commons-validator          |                          |        21      | 1-2,4,6-9,11,</br>13-25 |
| 66     | Pool            | commons-pool               |                          |        17      | 1,5-7,10-14,</br>16,20-21,24,</br>26-27,29-30|
| 67     | Net             | commons-net                |                          |        14      | 9,10,12,</br>14-18,20-21,</br>23-26             |
| 68     | Numbers_angle   | commons-numbers-angle            |  commons-numbers<br/>-angle         |        2       | 1-2               |
| 69     | MGpg            | maven-gpg-plugin           ||        1       | 1               |
| 70     | Text            | commons-text               ||        4       | 1-2,4-5               |
| 71     | Tika_core            | tika-core               |  tika-core |        23       | 4,6,9,11,</br>17,20-25,28-39               |
| 72     | Tika_app            | tika-app               |   tika-app     |        2       | 1,3               |
| 73     | Shiro_core            | shiro-core               |      core      |        10       | 37,40,46,52,98,</br>144,176,181,202-203               |
| 74     | Jena_core            | jena-core               |    jena-core   |        1       | 2               |
| 75     | MDeploy            | maven-deploy-plugin               |              |        1       | 1               |
| 76     | Jackrabbit_filevault<br/>_vault_validation | jackrabbit-filevault<br/>-vault-validation               |       vault-validation       |        4       | 1-4               |
| 77     | Jackrabbit_oak_core            | oak-core               |       oak-core       |        5       | 1-5               |
| 78     | Maven_checkstyle<br/>_plugin            | maven-checkstyle<br/>-plugin               |             |        1       | 1               |
| 79     | James_project<br/>_core            | james-project-core               |       core       |        2       | 1-2               |
| 80     | Pdfbox_fontbox            | pdfbox-fontbox      |       fontbox      |        7       | 1-7               |
| 81     | HttpClient5            | httpclient5      |       httpclient5      |        7       | 1-2,4-8               |
| 82     | jackson_modules<br/>_java8_datetime      | jackson-modules<br/>-java8-datetime |      datetime  |        5       | 1-5               |
| 83     | Pdfbox_pdfbox         | pdfbox-pdfbox |    pdfbox    |        3      | 1-3               |
| 84     | Storm_client            | storm-client      |       storm-client      |        1       | 1              |
| 85     | JacksonDataformats<br/>Text_yaml            | jackson-dataformats<br/>-text-yaml |      yaml   |       6     | 1-2,4-7              |
| 86     | JacksonDataformats<br/>Text_properties            | jackson-dataformats<br/>-text-properties |      properties   |       2     | 1-2              |
| 87     | JacksonDataformat<br/>Binary_avro            | jackson-dataformats<br/>-binary-avro |      avro   |       2     | 1-2              |
| 88     | JavaClassmate            | java-classmate |        |       2     | 1-2              |
| 89     | JacksonModule<br/>JsonSchema            | jackson-module-<br/>jsonSchema |      |       1     | 1              |
| 90     | JacksonData<br/>typeJoda            | jackson-datatype-joda |        |       2     | 2-3              |
| 91     | JacksonDatatype<br/>Jsr310            | jackson-datatype-jsr310 |         |       4     | 1-4              |
| 92     | JacksonDataformat<br/>Binary_smile            | jackson-dataformats<br/>-binary-smile |    smile     |       3     | 1-3              |
| 93     | JacksonModule<br/>Afterburner            | jackson-module-afterburner |         |       3     | 1-3              |
| 94     | Woodstox            | woodstox |         |       7     | 1-7              |
| 95     | MetaModel_core            | MetaModel-core | core        |       9     | 1-9              |
| 96     | MetaModel_csv            | MetaModel-csv |  csv       |       1     | 1              |
| 97     | MetaModel_excel            | MetaModel-excel |  excel        |       1     | 1              |
| 98     | MetaModel_jdbc            | MetaModel-jdbc |  jdbc       |       3     | 1-3              |
| 99     | MetaModel_pojo            | MetaModel-pojo |  pojo       |       1     | 1              |
| 100     | MetaModel_<br/>salesforce            | MetaModel-salesforce |   salesforce      |       1     | 1              |
| 101     | Wink_common            | wink-common |  wink-common       |       4     | 1-4              |
| 102     | Xbean_naming            | xbean-naming |  xbean-naming       |       1     | 1              |
| 103     | James_project_<br/>server_container<br/>_core            | james-project-server-<br/>container-core |  server/container/core       |       1     | 1              |
| 104     | Johnzon_core            | johnzon-core |  johnzon-core       |       11     | 1-2,4-12              |
| 105     | Nifi_mock            | nifi-mock |  nifi-mock       |       2     | 1-2              |
| 106     | Rat_core            | apache-rat-core |  apache-rat-core       |       1     | 1              |
| 107     | Rat_plugin            | apache-rat-plugin |  apache-rat-plugin       |       1     | 1              |
| 108     | Tez_common            | tez-common |  tez-common       |       1     | 1              |
| 109     | Tinkerpop_gremlin<br/>_core            | gremlin-core |  gremlin-core       |       1     | 1              |
| 110     | Webbeans_web            | webbeans-web |  webbeans-web       |       1     | 1              |
| 111     | Johnzon_jsonb            | johnzon-jsonb |  johnzon-jsonb       |       6     | 1-6              |
| 112     | Johnzon_jaxrs            | johnzon-jaxrs |  johnzon-jaxrs       |       1     | 1              |
| 113     | Incubator_tamaya<br/>_api            | incubator-retired<br/>-tamaya-api |  code/api       |       2     | 1-2              |
| 114     | James_project_<br/>mailet_standard            | james-project-<br/>mailet-standard |  mailet/standard       |       1     | 1              |
| 115     | Johnzon_<br/>jsonschema            | johnzon-jsonschema |  johnzon-jsonschema       |       2     | 1-2              |
| 116     | Johnzon_<br/>mapper            | johnzon-mapper |  johnzon-mapper       |       6     | 1-6              |
| 117     | Karaf_main            | karaf-main |  main       |       1     | 1              |
| 118     | Appformer_uberfire<br/>_commons_editor<br/>_backend            | uberfire-commons-editor-backend |  uberfire-extensions<br/>/uberfire-commons-editor/<br/>uberfire-commons-editor-backend       |       1     | 1              |
| 119     | Kie_pmml_<br/>commons            | kie-pmml-commons |  kie-pmml-trusty/<br/>kie-pmml-commons       |       3     | 1-3              |
| 120     | Kie_memory_<br/>compiler            | kie-memory-compiler |  kie-memory-compiler       |       1     | 1              |
| 121     | Jbpm_human<br/>_task_workitems            | jbpm-human-task-workitems |  jbpm-human-task/<br/>jbpm-human-task-workitems       |       1     | 1              |
| 122     | Appformer_uberfire_<br/>security_management</br>_client            | uberfire-security-management-client | uberfire-extensions<br/>/uberfire-security<br/>/uberfire-security-management<br/>/uberfire-security<br/>-management-client  |       1     | 1              |
| 123     | Appformer_uberfire<br/>_workbench_client            | uberfire-workbench-client |  uberfire-workbench/<br/>uberfire-workbench-client       |       3     | 1-3              |
| 124     | Jandex            | jandex |         |       6     | 1-6              |
| 125     | Kogito_editors<br/>_java_kie_wb<br/>_common_stunner<br/>_widgets            | kie-wb-common-<br/>stunner-widgets |  kie-wb-common-stunner/<br/>kie-wb-common-stunner-client/<br/>kie-wb-common-stunner-widgets       |       1     | 1              |
| 126     | Ognl            | commons-ognl |         |       1     | 1              |
| 127     | Qpid_client            | qpid-jms-client |  qpid-jms-client       |       8     | 1-8              |
| 128     | Switchyard_admin            | switchyard-admin |  admin       |       1     | 1              |
| 129     | Weld_se_core            | weld-se-core |  environments/se/core       |       1     | 1              |
| 130     | Jboss_modules            | jboss-modules |        |       5     | 1,3-6              |
| 131     | Jboss_threads            | jboss-threads |        |       1     | 1              |
| 132     | Minaftp_api            | ftpserver-api |  ftplet-api       |       1     | 1              |
| 133     | Sling_<br/>validation            | sling-org-apache-sling-validation-core |       |       1     | 1              |
| 134     | Switchyard_<br/>config            | switchyard-config |  config       |       1     | 1              |
| 135     | Switchyard_<br/>validate            | switchyard-validate |  validate       |       1     | 1              |
| 136     | Wildfly_naming<br/>_client            | wildfly-naming-client |     |       2     | 1-2              |
| 137     | Knox_assertion<br/>_common            | gateway-provider-</br>identity-assertion</br>-common |  gateway-provider-</br>identity-assertion</br>-common     |       1     | 1              |
| 138     | Oozie_client            | oozie-client | client |       2     | 1-2              |
| 139     | Qpidjms_client            | qpidjms-client | client  |       3     | 1-3              |
| 140     | Rdf4j_query            | rdf4j-query | core/query    |       1     | 1              |
| 141     | Rdf4j_rio_api            | rdf4j-rio-api | core/rio/api  |       2     | 1-2              |
| 142     | Rdf4j_rio_jsonld            | rdf4j-rio-jsonld | core/rio/jsonld  |       2     | 1-2              |
| 143     | Rdf4j_rio_rdfjson            | rdf4j-rio-rdfjson | core/rio/rdfjson |       2     | 1-2              |
| 144     | Rdf4j_rio_rdfxml            | rdf4j-rio-rdfxml | core/rio/rdfxml    |       1     | 1              |
| 145     | Rdf4j_rio_turtle            | rdf4j-rio-turtle | core/rio/turtle    |       8    | 1-4,6,8-10              |
| 146     | Sentry_ccommon            | sentry-core-common |  sentry-core/sentry-core-common   |       2     | 1-2              |
| 147     | Sling_apiregions            | sling-apiregions |     |       3     | 1-3              |
| 148     | Sling_cpconverter            | sling-cpconverter |     |       3     | 1-3              |
| 149     | Tiles_api            | tiles-api | tiles-api    |       2     | 1-2              |
| 150     | Tiles_core            | tiles-core |  tiles-core   |       3     | 1-3              |
| 151     | Twill_dcore            | twill-discovery-core |  twill-discovery-core   |       1     | 1              |
| 152     | Maven2_artifact            | maven-artifact |  maven-artifact   |       2     | 1-2              |
| 153     | Maven2_project            | maven-project |  maven-project   |       2     | 1-2              |
| 154     | Wicket_request            | wicket-request               |     wicket-request                     |      6       | 1-6               |
| 155     | Cayenne_xmpp            | cayenne-xmpp               |    cayenne-xmpp                      |      1       | 1               |
| 156     | Wicket_util            | wicket-util               |     wicket-util                     |     4       | 1-4               |
| 157     | Wicket_spring            | wicket-spring               |        wicket-spring                  |      1       | 1               |
| 158     | Cayenne_jgroups            | cayenne-jgroups               |    cayenne-jgroups                      |      1       | 1               |
| 159     | Cayenne_jms            | cayenne-jms               |     cayenne-jms                     |      1       | 1               |
| 160     | Struts1_core            | struts1-core               |     core                     |      2       | 1-2               |
| 161     | Wicket_cdi            | wicket-cdi               |     wicket-cdi                     |      1       | 1               |
| 162     | Wicket_core            | wicket-core               |     wicket-core                     |      18       | 1-18               |
| 163     | Mshared_<br/>archiver            | maven-archiver               |     maven-archiver                     |      1       | 1               |
| 164     | Shindig_<br/>common            | shindig-common               |     java/common                     |      1       | 1               |
| 165     | Xbean_<br/>reflect            | xbean-reflect               |     xbean-reflect                     |      1       | 1               |
| 166     | Mrunit            | mrunit               |                          |      2       | 1-2               |
| 167     | Rave_core            | rave-core               |          rave-components<br/>/rave-core         |      2       | 1-2               |
| 168     | Rave_commons            | rave-commons               |          rave-components<br/>/rave-commons         |      1       | 1               |
| 169     | Rave_web            | rave-web               |          rave-components/rave-web         |      1       | 1               |
| 170     | Jmh_core            | jmh-core               |          jmh-core         |      1       | 1               |
| 171     | Sdk_core            | sdk-core               |                   |      3       | 1-3               |
| 172     | Cargo_<br/>container            | cargo-container               |          core/api/<br/>container         |      4       | 1-4               |
| 173     | Oak_commons            | oak-commons               |          oak-commons         |      1       | 1               |
| 174     | Streamex            | streamex               |                   |      7       | 1-7               |
| 175     | Javapoet            | javapoet               |                   |      17       | 1-17               |
| 176     | RTree            | rtree               |                   |      12       | 1-12               |
| 177     | Spoon            | spoon               |                   |      17       | 1-17               |
| 178     | Slack_java<br/>_webhook            | slack-java-webhook               |                 |      1       | 1               |
| 179     | Zip4j            | zip4j               |                  |      52       | 1-52               |
| 180     | Incubator_<br/>retired_pirk            | incubator-retired-pirk               |                  |      1       | 1               |
| 181     | Sparsebitset             | SparseBitSet                |                  |      2       | 1-2               |
| 182     | Assertj_assert<br/>ions_generator            | assertj-assertions<br/>-generator               |                  |      7       | 1-7               |
| 183     | Config_magic            | config-magic               |                  |      2       | 2               |
| 184     | Jcodemodel            | jcodemodel               |                  |      7       | 1-7               |
| 185     | Jdbm3            | JDBM3               |                  |      6       | 1-6               |
| 186     | Mybatis_<br/>pagehelper            | Mybatis-PageHelper               |                  |      4       | 1-4               |
| 187     | N5            | n5               |                  |      2       | 1-2               |
| 188     | Stash_jenkins_<br/>postreceive<br/>_webhook            | stash-jenkins<br/>-postreceive-webhook               |                  |      1       | 1               |
| 189     | Suffixtree            | suffixtree               |                  |      1       | 1               |
| 190     | Template_<br/>benchmark            | template-benchmark               |                  |      1       | 1               |
| 191     | Vectorz            | vectorz               |                  |      6       | 1-6               |
| 192     | Cli_parser         | cli-parser            |                  |      1       | 1                  |                 |
| 193     | Gatling_report         | gatling-report            |                  |      3       | 1-3                  |                 |
| 194     | Semux_core         | semux-core            |                  |      1       | 3                  |                 |
| 195     | Solarpositioning         | solarpositioning            |                  |      3       | 1-3                  |                 |
| 196     | Sparkey_java         | sparkey-java            |                  |      3       | 1-3                  |                 |
| 197     | Shazamcrest         | shazamcrest            |                  |      2       | 1-2                  |                 |
| 198     | Restfixture         | RestFixture            |                  |      4       | 1-4                  |                 |
| 199     | Chronicle_network         | Chronicle-Network            |                  |      4       | 1-4                  |                 |
| 200     | Gocd_slack_build<br/>_notifier         | gocd-slack-<br/>build-notifier            |                  |      3       | 1-3                  |                 |
| 201     | Confluence_http<br/>_authenticator         | confluence_http<br/>_authenticator            |                  |      1       | 1                  |                 |
| 202     | Tempus_fugit         | tempus-fugit            |                  |      1       | 1                  |                 |
| 203     | Kafka_graphite         | kafka-graphite           |                  |      1       | 1                  |                 |
| 204     | Simple_excel         | simple-excel           |                  |      1       | 1                  |                 |
| 205     | Trident_ml         | trident-ml           |                  |      1       | 1                  |                 |
| 206     | Tascalate_<br/>concurrent         | tascalate-concurrent           |                  |      2       | 1-2                  |                 |
| 207     | Jcabi_github         | jcabi-github           |                  |      81       | 1-42,44-82                  |
| 208     | Podam         | podam           |                  |      1       | 1                  |
| 209     | Sansorm         | SansOrm           |                  |      7       | 1-7                  |
| 210     | Transmittable_<br/>thread_local         | transmittable<br/>-thread-local           |                  |      4       | 1-4                  |
| 211     | Jchronic         | jchronic           |                  |      1       | 1                  |
| 212     | Netconf_java         | netconf-java           |                  |      1       | 1                  |
| 213     | Xades4j         | xades4j           |                  |      4       | 1-4                  |
| 214     | Spatial4j         | spatial4j           |                  |      4       | 1-4                  |
| 215     | Iciql         | iciql           |                  |      2       | 1-2                  |
| 216     | Metrics_opentsdb         | metrics-opentsdb           |                  |      2       | 1-2                  |
| 217     | Spring_context<br/>_support         | spring-context<br/>-support           |                  |      1       | 2                  |
| 218     | Jmimemagic         | jmimemagic           |                  |      1       | 1                  |
| 219     | Markedj         | markedj           |                  |      17       | 1-17                  |
| 220     | Sonartsplugin         | SonarTsPlugin           |                  |      10       | 1-10                  |
| 221     | Aws_maven         | aws-maven           |                  |      1       | 1                  |
| 222     | Snomed_owl<br/>_toolkit         | snomed-owl<br/>-toolkit           |                  |      2       | 1-2                  |
| 223     | Weak_lock_free         | weak-lock-free           |                  |      1       | 1                  |
| 224     | Proj4J         | proj4j           |                  |      9       | 1-9                  |
| 225     | Markedj         | markedj           |                  |      2       | 1-2                  |
| 226     | Rocketmq_<br/>mqtt_ds         | rocketmq-mqtt-ds           |       mqtt-ds           |      1       | 1                  |
| 227     | Retrofit         | retrofit           |       retrofit           |      3       | 1-3                  |
| 228     | Jnagmp         | jnagmp           |       jnagmp           |      1       | 1                  |
| 229     | Rocketmq_<br/>mqtt_cs         | rocketmq-mqtt-cs           |       mqtt-cs           |      1       | 1   |
| 230     | Dagger_core         | dagger-core           |       core           |      20       | 1-20                  |
| 231     | Google_java<br/>_format_core         | google-java<br/>-format-core           |       core           |      1       | 1                  |
| 232     | Jimfs         | jimfs           |       jimfs           |      2       | 1-2                  |
| 233     | Open_location<br/>_code_java         | open-location<br/>-code-java           |       java           |      4       | 1-4                  |
| 234     | Gwtmockito         | gwtmockito           |       gwtmockito           |      3       | 1-3                  |
| 235     | Render_app         | render-app           |       render-app           |      5       | 1-5                  |
| 236     | Tape         | tape           |         tape         |      13       | 1-13                  |
| 237     | Jcabi_http         | jcabi-http           |                  |      16       | 1-16                  |
| 238     | Jcabi_aether         | jcabi-aether           |                  |      1       | 1                  |
| 239     | Jcabi_w3c            | jcabi-w3c                       |                           |       1       | 1                |
| 240     | Jcabi_email            | jcabi-email                       |        |       4       | 1-4                |
| 241     | Jcabi_log            | jcabi-log                       |                        |       9       | 1-9                |
| 242     | Jcabi_matchers            | jcabi-matchers                       |                        |       2       | 1-2                |
| 243     | Jfreechart_fse            | jfreechart-fse                       |                        |       2       | 1-2                |
| 244     | Jfreesvg            | jfreesvg                       |                        |       1       | 1                |
| 245     | Leshan_core         | leshan-core           |       leshan-core      |      10       | 1-10                  |    
| 246     | Rdf_jena            | commons-rdf-jena               |       commons-rdf-jena       |        1       | 1               |
| 247     | Jackson_<br/>annotations         | jackson-annotations           |               |      1       | 1                  |
| 248     | Jackson_datatype<br/>_hibernate4         | jackson-datatype<br/>-hibernate4           |   hibernate4   |      1       | 1                  |
| 249     | Rtree2         | rtree2           |         |      6       | 1-6                |              
| 250     | Subethasmtp         | subethasmtp           |         |      1       | 1                |

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
