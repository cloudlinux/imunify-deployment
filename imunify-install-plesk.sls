register_plesk_license:
  cmd.run:
    - name: /usr/local/psa/bin/license --install {{ pillar.get('plesk_license_key', 'NONE') }}
    - retry:
        attempts: 2
        interval: 5
        until: test $? -eq 0

install_plesk_extension:
  cmd.run:
    - name: plesk bin extension --install imunify360
    - require:
      - cmd: register_plesk_license
    - retry:
        attempts: 5
        interval: 30
        until: test $? -eq 0

# Check if modsecurity is installed in Plesk
check_plesk_modsecurity:
  cmd.run:
    - name: /usr/local/psa/bin/server_pref --show-web-app-firewall >/dev/null 2>&1 && ls /usr/local/psa/admin/sbin/modsecurity_ctl >/dev/null 2>&1
    - failhard: False
    - register: modsecurity_status

# Install modsecurity in Plesk if needed
install_plesk_modsecurity:
  cmd.run:
    - name: plesk installer --select-release-current --install-component modsecurity
    - require:
      - cmd: check_plesk_modsecurity
    - onfail:
      - cmd: check_plesk_modsecurity
    - retry:
        attempts: 10
        interval: 30
        until: /usr/local/psa/bin/server_pref --show-web-app-firewall >/dev/null 2>&1 && ls /usr/local/psa/admin/sbin/modsecurity_ctl >/dev/null 2>&1

