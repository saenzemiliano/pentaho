  <%--
  * This program is free software; you can redistribute it and/or modify it under the
  * terms of the GNU Lesser General Public License, version 2.1 as published by the Free Software
  * Foundation.
  *
  * You should have received a copy of the GNU Lesser General Public License along with this
  * program; if not, you can obtain a copy at http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html
  * or from the Free Software Foundation, Inc.,
  * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
  *
  * This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
  * without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  * See the GNU Lesser General Public License for more details.
  *
  * Copyright (c) 2002-2013 Pentaho Corporation..  All rights reserved.
  --%>

  <!DOCTYPE html>
  <%@page import="org.pentaho.platform.api.engine.IAuthorizationPolicy" %>
  <%@page import="org.pentaho.platform.api.engine.IPluginManager" %>
  <%@page import="org.pentaho.platform.engine.core.system.PentahoSessionHolder" %>
  <%@page import="org.pentaho.platform.engine.core.system.PentahoSystem" %>
  <%@page import="org.pentaho.platform.security.policy.rolebased.actions.AdministerSecurityAction" %>
  <%@page import="org.pentaho.platform.security.policy.rolebased.actions.RepositoryCreateAction" %>
  <%@page import="java.util.List" %>
  <%@page import="java.util.Locale"%>
  <%@page import="javax.servlet.http.HttpServletRequest"%>
  <%
    boolean canCreateContent = PentahoSystem.get( IAuthorizationPolicy.class, PentahoSessionHolder.getSession() )
        .isAllowed( RepositoryCreateAction.NAME );
    boolean canAdminister = PentahoSystem.get( IAuthorizationPolicy.class, PentahoSessionHolder.getSession() )
        .isAllowed( AdministerSecurityAction.NAME );
    List<String> pluginIds =
        PentahoSystem.get( IPluginManager.class, PentahoSessionHolder.getSession() ).getRegisteredPlugins();
    Locale locale = request.getLocale();
  %>
  <html lang="en" class="bootstrap">
  <head>
    <meta charset="utf-8">
    <title>Home Page</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="locale" content="<%=locale.toString()%>">

    <!-- Le styles -->
    <link href="css/home.css" rel="stylesheet">

    <!-- We need web context for requirejs and css -->
    <script type="text/javascript" src="webcontext.js?context=mantle&cssOnly=true"></script>
  <%
  // For consistency, we're using the same method as PentahoWebContextFilter to get scheme
  if ( PentahoSystem.getApplicationContext().getFullyQualifiedServerURL().toLowerCase().startsWith( "https:" ) ) {
  %>
    <script language='JavaScript' type='text/javascript' src='https://sadmin.brightcove.com/js/BrightcoveExperiences.js'></script>
  <% } else { %>
    <script language='JavaScript' type='text/javascript' src='http://admin.brightcove.com/js/BrightcoveExperiences.js'></script>
  <% } %>


    <!-- Avoid 'console' errors in browsers that lack a console. -->
    <script type="text/javascript">
      if (!(window.console && console.log)) {
        (function () {
          var noop = function () {
          };
          var methods = ['assert', 'debug', 'error', 'info', 'log', 'trace', 'warn'];
          var length = methods.length;
          var console = window.console = {};
          while (length--) {
            console[methods[length]] = noop;
          }
        }());
      }
    </script>

    <!-- Require Home -->
    <script type="text/javascript">
      var Home = null;
      require(["home/home", 
        "common-ui/util/ContextProvider"], function (pentahoHome, ContextProvider) {
        Home = pentahoHome;

        // Define properties for loading context
        var contextConfig = [
          {
            path: "properties/config",
            post: function (context, loadedMap) {
              context.config = loadedMap;
            }
          },
          {
            path: "properties/messages",
            post: function (context, loadedMap) {
              context.i18n = loadedMap;
            }
        }];

        // Define permissions
        ContextProvider.addProperty("canCreateContent", <%=canCreateContent%>);
        ContextProvider.addProperty("canAdminister", <%=canAdminister%>);
        ContextProvider.addProperty("hasAnalyzerPlugin", <%=pluginIds.contains("analyzer")%>);
        ContextProvider.addProperty("hasIRPlugin", <%=pluginIds.contains("pentaho-interactive-reporting")%>);
        ContextProvider.addProperty("hasDashBoardsPlugin", <%=pluginIds.contains("dashboards")%>);
        ContextProvider.addProperty("hasMarketplacePlugin", <%=pluginIds.contains("marketplace")%>);
        ContextProvider.addProperty("hasDataAccess", false); // default

        // BISERVER-8631 - Manage datasources only available to roles/users with appropriate permissions
        var serviceUrl = Home.getUrlBase() + "plugin/data-access/api/permissions/hasDataAccess";
        Home.getContent(serviceUrl, function (result) {
          ContextProvider.addProperty("hasDataAccess", result);
          ContextProvider.get(Home.init, contextConfig); // initialize
        }, function (error) {
          console.log(error);
          ContextProvider.get(Home.init, contextConfig); // log error and initialize anyway
        });

      });
    </script>

    <style>
      body {
          margin: 0;
          font-size: 19px !important;
      }

      ul {
          list-style-type: none;
          margin: 0;
          padding: 0;
          width: 20%;
          background-color: #f1f1f1;
          position: fixed;
          height: 100%;
          overflow: auto;
      }

      li a {
          display: block;
          color: #333  !important;
          padding: 8px 16px;
          text-decoration: none;
      }
      li {
          border-bottom: 1px solid #cac3c3;
          background: url(images/16x16_right.png);
          background-position: 95% center;
          background-repeat: no-repeat;
      }

      li:first-child {
          border-top:  1px solid #cac3c3;
      }

      li a.active {
          background-color: #4CAF50  !important;
          color: white  !important;
      }

      li a:hover:not(.active) {
          background-color: #555  !important;
          color: white  !important;
      }
    </style>
  </head>

  <body data-spy="scroll" data-target=".sidebar">


  <ul style="margin: 0px;">
    <li><a href="javascript:window.parent.mantle_setPerspective('browser.perspective')">Archivos</a></li>
    <li><a href="javascript:Home.openFile('Consulta OLAP','Consulta OLAP', 'content/saiku-ui/index.html?biplugin5=true');">Nueva Consulta OLAP</a></li>
  </ul>

  <div style="margin-left:20%;padding:1px 16px;">
    <h2 style="margin-top: 20px;">DATAWAREHOUSE SCIM</h2>
    <h3>Para crear un nueva consulta haga click en Nuevo Consulta OLAP.</h3>
    

  </div>

  <div class="container-fluid main-container">
    <div class="row-fluid">
      <div class="span3" id="buttonWrapper">


      </div>
      <div class="span9" style="overflow:visible">

        <div class="row-fluid welcome-container" style="height: 100%">
          <!--<iframe src="content/welcome/index.html" class='welcome-frame' frameborder="0" scrolling="no"></iframe> -->
        </div>

      </div>
    </div>
  </div>

  </body>
  </html>
