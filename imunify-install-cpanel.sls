ensure_mod_security2_installed:
  pkg.installed:
    - name: ea-apache24-mod_security2
    - version: latest

install_imunify360:
  pkg.installed:
    - name: imunify360-firewall-cpanel
    - version: latest
    - require:
      - pkg: ensure_mod_security2_installed

install_ui_cpanel_package:
  pkg.installed:
    - name: imunify-ui-firewall-cpanel

# Register product (if activation key provided)
register_product:
  cmd.run:
    - name: |
        output=$(imunify360-agent register {{ pillar.get('activation_key', 'IPL') }} 2>&1)
        if echo "$output" | grep -q "WARNING: Agent is already registered"; then
          exit 0
        else
          echo "$output"
          exit $?
        fi
    - require:
      - pkg: install_imunify360