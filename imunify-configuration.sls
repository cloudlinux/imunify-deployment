create_example_config:
  file.managed:
    - name: /etc/sysconfig/imunify360/imunify360.config.d/10-example.config
    - makedirs: True
    - mode: 644
    - contents: |
        ADMIN_CONTACTS:
          emails: []
          enable_icontact_notifications: true

accept_eula:
  cmd.run:
    - name: imunify360-agent eula accept
