#!/bin/bash

cat > /tmp/bennomailarchiv.schema <<EOF
## Attribute (1.3.6.1.4.1.30259.1.2.1)

# global attributes
attributetype ( 1.3.6.1.4.1.30259.1.2.1.1 NAME 'bennoContainer'
    DESC 'Benno Container the user has access to'
    EQUALITY caseExactMatch
    SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )

# user attributes
attributetype ( 1.3.6.1.4.1.30259.1.2.1.2 NAME 'bennoEmailAddress'
    DESC 'Additional E-Mail addresses that could be searched by user'
    EQUALITY caseIgnoreIA5Match
    SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )

attributetype ( 1.3.6.1.4.1.30259.1.2.1.3 NAME 'bennoRole'
    DESC 'Role of the user: [USER|ADMIN|REVISOR]'
    EQUALITY caseIgnoreIA5Match
    SYNTAX 1.3.6.1.4.1.1466.115.121.1.26{256} SINGLE-VALUE)

## Objektklassen (1.3.6.1.4.1.30259.1.2.2)

objectclass ( 1.3.6.1.4.1.30259.1.1.2.2 NAME 'BennoMailarchivUser'
    DESC 'Per user configuration data of Benno Mailarchiv' SUP top AUXILIARY
    MAY  ( bennoContainer $ bennoEmailAddress $ bennoRole ) )
EOF

cat > /tmp/benno_syntax.py <<EOF
from univention.admin.syntax import select


class bennoRole(select):

	choices = [
		('USER', 'Benutzer'),
		('ADMIN', 'Administrator'),
		('REVISOR', 'Revisor'),
	]
EOF

export UNIVENTION_APP_IDENTIFIER="Benno MailArchiv"
. /usr/share/univention-lib/ldap.sh

# register LDAP schema

ucs_registerLDAPExtension "$@" --schema /tmp/bennomailarchiv.schema --packagename BennoMailArchiv --packageversion 1

# register "bennoRole" syntax
ucs_registerLDAPExtension "$@" --udm_syntax /tmp/benno_syntax.py --packagename BennoMailArchiv --packageversion 1

rm -f /tmp/bennomailarchiv.schema
rm -f /tmp/benno_syntax.py

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
	--set module=kopano/non-active \
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
	--set module=kopano/non-active \
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
	--set module=kopano/non-active \
	--set objectClass="BennoMailarchivUser" \
	--set ldapMapping="bennoRole" \
	--set tabName="Benno Mailarchiv" \
	--set tabPosition=1 \
	--set mayChange=1 \
	--set multivalue=0 \
	--set syntax=bennoRole

