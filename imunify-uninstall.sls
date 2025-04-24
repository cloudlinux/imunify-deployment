# Additional packages to remove
{% set additional_packages_to_remove = [
    "cloudlinux-backup-utils",
    "imunify360-ossec",
    "imunify360-pam",
    "imunify360-php-i360",
    "imunify360-webshield-bundle",
    "imunify360-unified-access-logger",
    "imunify-ui",
    "imunify-ui-firewall-cpanel",
    "imunify-ui-firewall-plesk"
] %}

# Handle uninstall if needed
uninstall_imunify360:
  pkg.removed:
    - name: imunify360-firewall


# Cleanup old packages if needed
cleanup_old_packages:
  pkg.removed:
    - pkgs: {{ additional_packages_to_remove }}
    - require:
      - uninstall_imunify360

get_hardened_php_status:
  cmd.run:
    - name: /usr/bin/imunify360-agent features status hardened-php --json | /opt/imunify360/venv/bin/python -c 'import json; print(json.loads(input()).get("items", {}).get("status"))'
    - onlyif: test -f /usr/bin/imunify360-agent

remove_hardened_php:
  cmd.run:
    - name: /usr/bin/imunify360-agent features remove hardened-php
    - require:
      - get_hardened_php_status
    - onlyif: test -f /usr/bin/imunify360-agent
    - onlyif: /usr/bin/imunify360-agent features status hardened-php --json | /opt/imunify360/venv/bin/python -c 'import json; print(json.loads(input()).get("items", {}).get("status"))' | grep -q "installed"

verify_removal:
  cmd.run:
    - name: /usr/bin/imunify360-agent features status hardened-php --json | /opt/imunify360/venv/bin/python -c 'import json; print(json.loads(input()).get("items", {}).get("status"))'
    - require:
      - remove_hardened_php
    - onlyif: test -f /usr/bin/imunify360-agent
    - failhard: True
    - retry:
        attempts: 50
        interval: 30
        until: /usr/bin/imunify360-agent features status hardened-php --json | /opt/imunify360/venv/bin/python -c 'import json; print(json.loads(input()).get("items", {}).get("status"))' | grep -q "not_installed"

# Remove Plesk extension if it exists
remove_plesk_extension:
  cmd.run:
    - name: /usr/local/psa/bin/extension --uninstall imunify360
    - onlyif: test -x /usr/local/psa/bin/extension
    - require:
      - pkg: uninstall_imunify360
