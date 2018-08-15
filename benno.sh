#!/bin/bash

export UNIVENTION_APP_IDENTIFIER="Benno MailArchiv"
. /usr/share/univention-lib/ldap.sh

# register LDAP schema
ucs_registerLDAPExtension "$@" --schema /tmp/bennomailarchiv.schema --packagename BennoMailArchiv --packageversion 1

# register "bennoRole" syntax
ucs_registerLDAPExtension "$@" --udm_syntax benno_syntax.py --packagename BennoMailArchiv --packageversion 1

eval "$(univention-config-registry shell)"

# create container for custom attributes
univention-directory-manager container/cn create "$@" \
	--position "cn=custom attributes,cn=univention,$ldap_base" \
	--set name="benno" \
	--set description="benno Mail Archive"

# create custom attributes
univention-directory-manager settings/extended_attribute create "$@" \
	--position="cn=benno,cn=custom attributes,cn=univention,$ldap_base" \
	--set name="bennoContainer" \
	--set CLIName="bennoContainer" \
	--set shortDescription="benno Container auf den der Benuzter Zugriff hat" \
	--set module=users/user \
	--set module=groups/group \
	--set objectClass="BennoMailarchivUser" \
	--set ldapMapping="bennoContainer" \
	--set tabName="Benno Mailarchiv" \
	--set tabPosition=2 \
	--set mayChange=1 \
	--set multivalue=1 \
	--set syntax=string

univention-directory-manager settings/extended_attribute create "$@" \
	--position="cn=benno,cn=custom attributes,cn=univention,$ldap_base" \
	--set name="bennoEmailAddress" \
	--set CLIName="bennoEmailAddress" \
	--set shortDescription="benno Adressliste für Zugriffssteuerung" \
	--set module=users/user \
	--set module=groups/group \
	--set objectClass="BennoMailarchivUser" \
	--set ldapMapping="bennoEmailAddress" \
	--set tabName="Benno Mailarchiv" \
	--set tabPosition=3 \
	--set mayChange=1 \
	--set multivalue=1 \
	--set syntax=string


univention-directory-manager settings/extended_attribute create "$@" \
	--position="cn=benno,cn=custom attributes,cn=univention,$ldap_base" \
	--set name="bennoRole" \
	--set CLIName="bennoRole" \
	--set shortDescription="benno Rolle" \
	--set module=users/user \
	--set module=groups/group \
	--set objectClass="BennoMailarchivUser" \
	--set ldapMapping="bennoRole" \
	--set tabName="Benno Mailarchiv" \
	--set tabPosition=1 \
	--set mayChange=1 \
	--set multivalue=0 \
	--set syntax=bennoRole

