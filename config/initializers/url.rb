class Hash
  def get(path)
    ret = self
    path.split('.').each do |p|
      if p.to_i.to_s == p
        ret = ret[p.to_i]
      else
        ret = ret[p.to_s] || ret[p.to_sym]
      end
      break unless ret
    end
    ret
  end
end

STATIC_PATH = YAML.load_file "#{APP_CONFIG["root"]}/config/routes/static.yml"
# API_PATH = YAML.load_file "#{APP_CONFIG["root"]}/config/routes/api.yml"
# ADMIN_PATH = YAML.load_file "#{APP_CONFIG["root"]}/config/routes/admin.yml"