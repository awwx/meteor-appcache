Package.describe({
  summary: "experimental appcache support"
});

Package.on_use(function (api) {
  api.use('startup', 'client');
  api.add_files('appcache-client.js', 'client');
  api.add_files('appcache-server.js', 'server');
});
