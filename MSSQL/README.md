# MSSQL

## Installing mssql-cli

```bash
    # install pip
    sudo easy_install pip

    # Update pip
    python -m pip install --upgrade pip

    # Install mssql-cli
    sudo pip install mssql-cli

    # Run mssql-cli
    mssql-cli

    # Uninstalling mssql-cli
    sudo pip uninstall mssql-cli

    # Backup Example (SQLCMD)
    sqlcmd -S 192.168.0.8,PORT -U sa -Q " Backup Database [Buddham] TO DISK = '/var/opt/mssql/data/Backup/Buddham-first.BAK'"

    # Backup (T-SQL)
    Backup DAtabase [Buddham] TO DISK = '/var/opt/mssql/data/Backup/Buddham-first.BAK'

    # Restore Example (SQLCMD)
    $ Sqlcmd -S 192.168.0.8,PORT -U sa -Q " Restore Database [Buddham] From DISK = '/var/opt/mssql/data/Backup/Buddham-first.Bak'"

    # Restore (T-SQL)
    Restore Database [Buddham] TO DISK = '/var/opt/mssql/data/Backup/Buddham-first.Bak'

    # [ -E trusted connection ]
    # [ -S server ]
    # [ -Q "CMD line query" and exit ]

    # Get Seed
    SELECT IDENT_SEED('<Table Name>') AS Identity_Seed;

    # Truncate Table
    truncate table <Table Name>;
    go

```
