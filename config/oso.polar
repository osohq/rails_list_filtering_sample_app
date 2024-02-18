actor User {}

resource Project {
  roles = ["owner"];
}

resource Article {
  permissions = ["view"];
  relations = { project: Project };

  "view" if "owner" on "project";
  "view" if is_public(resource);
}