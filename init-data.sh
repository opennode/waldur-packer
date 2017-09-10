#!/bin/bash -ex

yum -y install jq python2-httpie

auth_token=$(http -b --ignore-stdin POST "http://localhost/api-auth/password/" username=admin password=admin \
    | jq -r '.token')

# Add users
usr_ao_url=$(http -b --ignore-stdin POST "http://localhost/api/users/" Authorization:"token $auth_token" \
    email="owner@a.org" full_name="A Owner" username="a.owner" | jq -r '.url')
http -b --ignore-stdin POST "${usr_ao_url}password/" Authorization:"token $auth_token" password="Password1" | jq -r '.'

usr_a1a_url=$(http -b --ignore-stdin POST "http://localhost/api/users/" Authorization:"token $auth_token" \
    email="admin1@a.org" full_name="A1 Admin" username="a1.admin" | jq -r '.url')
http -b --ignore-stdin POST "${usr_a1a_url}password/" Authorization:"token $auth_token" password="Password1" | jq -r '.'

usr_a1m_url=$(http -b --ignore-stdin POST "http://localhost/api/users/" Authorization:"token $auth_token" \
    email="manager1@a.org" full_name="A1 Manager" username="a1.manager" | jq -r '.url')
http -b --ignore-stdin POST "${usr_a1m_url}password/" Authorization:"token $auth_token" password="Password1" | jq -r '.'

usr_a2a_url=$(http -b --ignore-stdin POST "http://localhost/api/users/" Authorization:"token $auth_token" \
    email="admin2@a.org" full_name="A2 Admin" username="a2.admin" | jq -r '.url')
http -b --ignore-stdin POST "${usr_a2a_url}password/" Authorization:"token $auth_token" password="Password1" | jq -r '.'

usr_a2m_url=$(http -b --ignore-stdin POST "http://localhost/api/users/" Authorization:"token $auth_token" \
    email="manager2@a.org" full_name="A2 Manager" username="a2.manager" | jq -r '.url')
http -b --ignore-stdin POST "${usr_a2m_url}password/" Authorization:"token $auth_token" password="Password1" | jq -r '.'

usr_bo_url=$(http -b --ignore-stdin POST "http://localhost/api/users/" Authorization:"token $auth_token" \
    email="owner@b.org" full_name="B Owner" username="b.owner" | jq -r '.url')
http -b --ignore-stdin POST "${usr_bo_url}password/" Authorization:"token $auth_token" password="Password1" | jq -r '.'

usr_b1a_url=$(http -b --ignore-stdin POST "http://localhost/api/users/" Authorization:"token $auth_token" \
    email="admin1@b.org" full_name="B1 Admin" username="b1.admin" | jq -r '.url')
http -b --ignore-stdin POST "${usr_b1a_url}password/" Authorization:"token $auth_token" password="Password1" | jq -r '.'

usr_b1m_url=$(http -b --ignore-stdin POST "http://localhost/api/users/" Authorization:"token $auth_token" \
    email="manager1@b.org" full_name="B1 Manager" username="b1.manager" | jq -r '.url')
http -b --ignore-stdin POST "${usr_b1m_url}password/" Authorization:"token $auth_token" password="Password1" | jq -r '.'

usr_b2a_url=$(http -b --ignore-stdin POST "http://localhost/api/users/" Authorization:"token $auth_token" \
    email="admin2@b.org" full_name="B2 Admin" username="b2.admin" | jq -r '.url')
http -b --ignore-stdin POST "${usr_b2a_url}password/" Authorization:"token $auth_token" password="Password1" | jq -r '.'

usr_b2m_url=$(http -b --ignore-stdin POST "http://localhost/api/users/" Authorization:"token $auth_token" \
    email="manager2@b.org" full_name="B2 Manager" username="b2.manager" | jq -r '.url')
http -b --ignore-stdin POST "${usr_b2m_url}password/" Authorization:"token $auth_token" password="Password1" | jq -r '.'

usr_s_url=$(http -b --ignore-stdin POST "http://localhost/api/users/" Authorization:"token $auth_token" \
    email="support@example.org" full_name="Global Support" is_support="true" username="support" | jq -r '.url')
http -b --ignore-stdin POST "${usr_s_url}password/" Authorization:"token $auth_token" password="Password1" | jq -r '.'

# Add organizations
org_a_url=$(http -b --ignore-stdin POST "http://localhost/api/customers/" Authorization:"token $auth_token" \
    name="Organization A" | jq -r '.url')
http -b --ignore-stdin POST "http://localhost/api/customer-permissions/" Authorization:"token $auth_token" \
    customer="$org_a_url" role="owner" user="$url_ao_url" | jq -r '.'

org_b_url=$(http -b --ignore-stdin POST "http://localhost/api/customers/" Authorization:"token $auth_token" \
    name="Organization B" | jq -r '.url')
http -b --ignore-stdin POST "http://localhost/api/customer-permissions/" Authorization:"token $auth_token" \
    customer="$org_b_url" role="owner" user="$url_bo_url" | jq -r '.'

# Add projects
prj_a1_url=$(http -b --ignore-stdin POST "http://localhost/api/projects/" Authorization:"token $auth_token" \
    customer="$org_a_url" name="Project A1" | jq -r '.url')
http -b --ignore-stdin POST "http://localhost/api/project-permissions/" Authorization:"token $auth_token" \
    project="$prj_a1_url" user="$usr_a1a_url" role=admin | jq -r '.'
http -b --ignore-stdin POST "http://localhost/api/project-permissions/" Authorization:"token $auth_token" \
    project="$prj_a1_url" user="$usr_a1m_url" role=manager | jq -r '.'

prj_a2_url=$(http -b --ignore-stdin POST "http://localhost/api/projects/" Authorization:"token $auth_token" \
    customer="$org_a_url" name="Project A2" | jq -r '.url')
http -b --ignore-stdin POST "http://localhost/api/project-permissions/" Authorization:"token $auth_token" \
    project="$prj_a2_url" user="$usr_a2a_url" role=admin | jq -r '.'
http -b --ignore-stdin POST "http://localhost/api/project-permissions/" Authorization:"token $auth_token" \
    project="$prj_a2_url" user="$usr_a2m_url" role=manager | jq -r '.'

prj_b1_url=$(http -b --ignore-stdin POST "http://localhost/api/projects/" Authorization:"token $auth_token" \
   customer="$org_b_url" name="Project B1" | jq -r '.url')
http -b --ignore-stdin POST "http://localhost/api/project-permissions/" Authorization:"token $auth_token" \
    project="$prj_b1_url" user="$usr_b1a_url" role=admin | jq -r '.'
http -b --ignore-stdin POST "http://localhost/api/project-permissions/" Authorization:"token $auth_token" \
    project="$prj_b1_url" user="$usr_b1m_url" role=manager | jq -r '.'

prj_b2_url=$(http -b --ignore-stdin POST "http://localhost/api/projects/" Authorization:"token $auth_token" \
    customer="$org_b_url" name="Project B2" | jq -r '.url')
http -b --ignore-stdin POST "http://localhost/api/project-permissions/" Authorization:"token $auth_token" \
    project="$prj_b2_url" user="$usr_b2a_url" role=admin | jq -r '.'
http -b --ignore-stdin POST "http://localhost/api/project-permissions/" Authorization:"token $auth_token" \
    project="$prj_b2_url" user="$usr_b2m_url" role=manager | jq -r '.'
