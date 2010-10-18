#!/bin/ksh

PKG_LIST_FILE="$(dirname $(whence $0))/PACKAGES_LIST"
REPO_URL_MAIN="http://pkg.openindiana.org/dev"
REPO_URL_LGCY="http://pkg.openindiana.org/legacy"


echo "Content-type: text/xml"
echo

case "$REQUEST_METHOD" in
  POST|post)
    cat <<EOF
<!DOCTYPE auto_install SYSTEM "file:///usr/share/auto_install/ai.dtd">
<auto_install>
  <ai_instance name="default">
    <software>
      <source>
        <publisher name="openindiana.org">
          <origin name="${REPO_URL_MAIN}"/>
        </publisher>
      </source>
      <source>
        <publisher name="opensolaris.org">
          <origin name="${REPO_URL_LGCY}"/>
        </publisher>
      </source>
      <software_data action="install" type="IPS">
EOF
    while read PKGN; do
      echo "        <name>pkg:/${PKGN}</name>"
    done < "$PKG_LIST_FILE"
    cat <<EOF
      </software_data>
    </software>
    <sc_embedded_manifest name="AI">
      <!-- <?xml version='1.0'?>
      <!DOCTYPE service_bundle SYSTEM "/usr/share/lib/xml/dtd/service_bundle.dtd.1">
      <service_bundle type="profile" name="system configuration">
        <service name="system/install/config" version="1" type="service">
          <instance name="default" enabled="true">
            <property_group name="user_account" type="application">
              <propval name="login" type="astring" value="jack"/>
              <propval name="password" type="astring" value="9Nd/cwBcNWFZg"/>
              <propval name="description" type="astring" value="default_user"/>
              <propval name="shell" type="astring" value="/usr/bin/bash"/>
              <propval name="uid" type='count' value='101'/>
              <propval name="gid" type='count' value='10'/>
              <propval name="type" type="astring" value="normal"/>
              <propval name="roles" type="astring" value="root"/>
            </property_group>

            <property_group name="root_account" type="application">
              <propval name="password" type="astring" value="\$5\$VgppCOxA\$ycFmYW4ObRRHhtsGEygDdexk5bugqgSiaSR9niNCouC"/>
              <propval name="type" type="astring" value="role"/>
            </property_group>

            <property_group name="other_sc_params" type="application">
              <propval name="timezone" type="astring" value="Australia/NSW"/>
              <propval name="hostname" type="astring" value="openindiana"/>
            </property_group>
          </instance>
        </service>
        <service name="system/console-login" version="1" type="service">
          <property_group name="ttymon" type="application">
            <propval name="terminal_type" type="astring" value="sun"/>
          </property_group>
        </service>

        <service name='system/keymap' version='1' type='service'>
          <instance name='default' enabled='true'>
            <property_group name='keymap' type='system'>
              <propval name='layout' type='astring' value='US-English'/>
            </property_group>
          </instance>
        </service>

        <service name="network/physical" version="1" type="service">
          <instance name="nwam" enabled="true"/>
          <instance name="default" enabled="false"/>
        </service>
      </service_bundle>
      -->
    </sc_embedded_manifest>
  </ai_instance>
</auto_install>
EOF
    ;;
  *) # GET and all other methods
    cat <<'EOF'
<CriteriaList>
  <Version Number="0.5"/>
</CriteriaList>
EOF
    ;;
esac

