# Pentaho Community Edition: Configurations

Configuration examples: Jackrabbit Repository over Oracle DB and DB Connection Pool

## Table of Contents

- [Jackrabbit Repository](#jackrabbit-repository)
- [DB Connection Pool](#db-vonnection-pool)
- [License](#license)

## Jackrabbit Repository

### Config repository.xml

Open file in [PENTAHO_HOME]/pentaho-solutions/system/jackrabbit/repository.xml. You must change next file properties. 
NOTE: Be carreful! this properties apear several times.
* [Download](Pentaho-Business-Analytics-7.1.0.0.12/Configuration/repository.xml) - Standar configuration file
```
<FileSystem class="org.apache.jackrabbit.core.fs.db.OracleFileSystem">
      <param name="url" value="jdbc:oracle:thin:@{SERVER}:{PORT}:{SID}" />
      <param name="user" value="{USER_NAME}"/>
      <param name="password" value="{USER_PASS}"/>
      <param name="schemaObjectPrefix" value="fs_ver_"/>
      <param name="tablespace" value="{TABLESPACE}"/>
</FileSystem>
```
```
<FileSystem class="org.apache.jackrabbit.core.fs.db.OracleFileSystem">
      <param name="url" value="jdbc:oracle:thin:@{SERVER}:{PORT}:{SID}" />
      <param name="user" value="{USER_NAME}"/>
      <param name="password" value="{USER_PASS}"/>
      <param name="schemaObjectPrefix" value="fs_ver_"/>
      <param name="tablespace" value="{TABLESPACE}"/>
</FileSystem>
```
```
<DataStore class="org.apache.jackrabbit.core.data.db.DbDataStore">
    <param name="driver" value="oracle.jdbc.OracleDriver"/>
    <param name="url" value="jdbc:oracle:thin:@{SERVER}:{PORT}:{SID}" />
    <param name="user" value="{USER_NAME}"/>
    <param name="password" value="{USER_PASS}" />
    <param name="databaseType" value="oracle"/>
    <param name="minRecordLength" value="1024"/>
    <param name="maxConnections" value="3"/>
    <param name="copyWhenReading" value="true"/>
    <param name="tablePrefix" value=""/>
    <param name="schemaObjectPrefix" value="ds_repos_"/>
</DataStore>
```
```
<PersistenceManager class="org.apache.jackrabbit.core.persistence.bundle.OraclePersistenceManager">
      <param name="driver" value="oracle.jdbc.OracleDriver"/>
      <param name="url" value="jdbc:oracle:thin:@{SERVER}:{PORT}:{SID}" />
      <param name="user" value="{USER_NAME}"/>
      <param name="password" value="{USER_PASS}"/>
      <param name="schema" value="oracle"/>
      <param name="schemaObjectPrefix" value="pm_ver_"/>
      <param name="tablespace" value="{TABLESPACE}"/>
</PersistenceManager>
```
```
<Cluster id="node_{NUMBER}" syncDelay="5">
    <Journal class="org.apache.jackrabbit.core.journal.OracleDatabaseJournal">
      <param name="revision" value="${rep.home}/revision.log"/>
      <param name="driver" value="oracle.jdbc.OracleDriver"/>
      <param name="url" value="jdbc:oracle:thin:@{SERVER}:{PORT}:{SID}" />
      <param name="user" value="{USER_NAME}"/>
      <param name="password" value="{USER_PASS}"/>
      <param name="schema" value="oracle"/>
      <param name="schemaObjectPrefix" value="cl_repos_"/>
      <param name="tablespace" value="{TABLESPACE}"/>
    </Journal>
</Cluster>
```

Note: 

1.  SERVIDOR: BD IP or Server Name
2.  PORT: DB port (8080)
3.  SID: Oracle DB SID
4.  TABLESPACE: DB Tablespace
5.  USER_NAME:  User name
6.  USER_PASS: User password
7.  NUMBER: Unique node number


## DB Connection Pool

### Create DB Connection Pool

Open file in [PENTAHO_HOME]/biserver-ce/tomcat/webapps/pentaho/META-INF/context.xml. You must change next file properties. 
NOTE: Be carreful! this properties apear several times.

```
<Resource name="jdbc/{POOL_NAME}" auth="Container" type="javax.sql.DataSource"
  factory="org.apache.commons.dbcp.BasicDataSourceFactory"  maxActive="20" maxIdle="5"
  maxWait="10000" username="{USER_NAME}" password="{USER_PASS}" 
  driverClassName="oracle.jdbc.OracleDriver" 
    url="jdbc:oracle:thin:@{SERVER}:{PORT}:{SID}" 
  validationQuery="SELECT 1 FROM DUAL"/>
```


## License

This project is licensed under the GNU GPLv3 - see the [LICENSE.md](LICENSE.md) file for details


