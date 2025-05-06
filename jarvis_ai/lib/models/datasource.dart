class Datasource {
  final String type;
  final String name;
  final Map<String, dynamic> credentials;

  Datasource({
    required this.type,
    required this.name,
    required this.credentials,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'credentials': credentials,
      };
}

class DatasourceRequest {
  final List<Datasource> datasources;

  DatasourceRequest({required this.datasources});

  Map<String, dynamic> toJson() => {
        'datasources': datasources.map((ds) => ds.toJson()).toList(),
      };
}