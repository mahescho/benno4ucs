#!/bin/bash

cat > /etc/univention/templates/info/benno-milter-postfix.info <<EOF
Type: subfile
Multifile: etc/postfix/main.cf
Subfile: etc/postfix/main.cf.d/99_benno_milter
Variables: mail/postfix/benno_milter_host
EOF

cat > /etc/univention/templates/files/etc/postfix/main.cf.d/99_benno_milter <<EOF
### Benno MailArchiv Milter
@!@
print 'smtpd_milters = inet:%s:22500' % configRegistry.get('mail/postfix/benno_milter_host')
print 'non_smtpd_milters = inet:%s:22500' % configRegistry.get('mail/postfix/benno_milter_host')
@!@
milter_default_action = tempfail
### Benno MailArchiv Milter
EOF

cat > /etc/univention/registry.info/variables/benno-milter-postfix.cfg <<EOF
[mail/postfix/benno_milter_host]
Description[de]=benno Mailarchiv Server
Type=str
Categories=service-mail
EOF

ucr register benno-milter-postfix

ucr set mail/postfix/benno_milter_host=benno-ucs.mydomain.local

service postfix reload


