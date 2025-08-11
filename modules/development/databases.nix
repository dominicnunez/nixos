# modules/development/databases.nix - PostgreSQL and database configuration
{ pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    enableTCPIP = true;

    # Development-friendly authentication
    authentication = pkgs.lib.mkOverride 10 ''
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      local   all             all                                     trust
      host    all             all             127.0.0.1/32            scram-sha-256
      host    all             all             ::1/128                 scram-sha-256
      host    all             all             0.0.0.0/0               scram-sha-256
    '';

    # Initialize with aural user and databases
    initialScript = pkgs.writeText "init-postgresql" ''
      CREATE ROLE aural WITH LOGIN PASSWORD 'devpass' CREATEDB SUPERUSER;
      CREATE DATABASE devdb OWNER aural;
      CREATE DATABASE testdb OWNER aural;

      -- Grant all privileges
      GRANT ALL PRIVILEGES ON DATABASE devdb TO aural;
      GRANT ALL PRIVILEGES ON DATABASE testdb TO aural;
    '';

    # Performance settings for development
    settings = {
      shared_buffers = "256MB";
      effective_cache_size = "1GB";
      maintenance_work_mem = "64MB";
      checkpoint_completion_target = 0.9;
      wal_buffers = "16MB";
      default_statistics_target = 100;
      random_page_cost = 1.1;
      effective_io_concurrency = 200;
      work_mem = "4MB";
      min_wal_size = "1GB";
      max_wal_size = "4GB";

      # Logging for development
      log_statement = "all";
      log_duration = true;
      log_line_prefix = "%m [%p] %q%u@%d ";
      log_min_duration_statement = 1000;  # Log slow queries (> 1 second)
    };
  };

  # Redis for caching
  services.redis.servers."main" = {
    enable = true;
    port = 6379;
    bind = "127.0.0.1";
    settings = {
      loglevel = "notice";
      databases = 16;
      save = [ "900 1" "300 10" "60 10000" ];
      maxmemory = "256mb";
      maxmemory-policy = "allkeys-lru";
    };
  };

  # Database management tools
  environment.systemPackages = with pkgs; [
    postgresql_16
    pgcli           # Better PostgreSQL CLI
    pgadmin4        # PostgreSQL GUI administration tool
    # dbeaver-bin     # Universal database tool
    redis
    mongodb-tools
    sqlite

    # Database migration tools
    flyway
  ];

  # Automatic PostgreSQL backup
  systemd.services.postgres-backup = {
    description = "PostgreSQL backup";
    serviceConfig = {
      Type = "oneshot";
      User = "postgres";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.postgresql_16}/bin/pg_dumpall > /var/backup/postgres/dump-$(date +%Y%m%d-%H%M%S).sql'";
    };
  };

  systemd.timers.postgres-backup = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  # Create backup directory
  systemd.tmpfiles.rules = [
    "d /var/backup/postgres 0755 postgres postgres -"
  ];
}
