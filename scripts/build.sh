#!/bin/sh
#
# Copyright 2023 Apollo Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# apollo config db info
apollo_config_db_url='jdbc:mysql://localhost:3306/ApolloConfigDB?characterEncoding=utf8'
apollo_config_db_username='root'
apollo_config_db_password='dengkaisheng8991'

# apollo portal db info
apollo_portal_db_url='jdbc:mysql://localhost:3306/ApolloPortalDB?characterEncoding=utf8'
apollo_portal_db_username='root'
apollo_portal_db_password='dengkaisheng8991'

# meta server url, different environments should have different meta server addresses
dev_meta=http://localhost:8080
fat_meta=http://localhost:8080
uat_meta=http://localhost:8080
pro_meta=http://localhost:8080

META_SERVERS_OPTS="-Ddev_meta=$dev_meta -Dfat_meta=$fat_meta -Duat_meta=$uat_meta -Dpro_meta=$pro_meta"

# =============== Please do not modify the following content =============== #
# go to script directory
cd "${0%/*}" || exit 

cd ..

# package config-service and admin-service
echo "==== starting to build config-service and admin-service ===="

mvn clean package -DskipTests -pl apollo-configservice,apollo-adminservice -am -Dapollo_profile=github -Dspring_datasource_url=$apollo_config_db_url -Dspring_datasource_username=$apollo_config_db_username -Dspring_datasource_password=$apollo_config_db_password

echo "==== building config-service and admin-service finished ===="

echo "==== starting to build portal ===="

mvn clean package -DskipTests -pl apollo-portal -am -Dapollo_profile=github,auth -Dspring_datasource_url=$apollo_portal_db_url -Dspring_datasource_username=$apollo_portal_db_username -Dspring_datasource_password=$apollo_portal_db_password $META_SERVERS_OPTS

echo "==== building portal finished ===="
