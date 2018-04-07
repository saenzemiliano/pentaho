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

  <%@ taglib prefix='c' uri='http://java.sun.com/jstl/core'%>
  <%@
      page language="java"
      import="org.springframework.security.ui.AbstractProcessingFilter,
              org.springframework.security.ui.webapp.AuthenticationProcessingFilter,
              org.springframework.security.ui.savedrequest.SavedRequest,
              org.springframework.security.AuthenticationException,
              org.pentaho.platform.uifoundation.component.HtmlComponent,
              org.pentaho.platform.engine.core.system.PentahoSystem,
              org.pentaho.platform.util.messages.LocaleHelper,
              org.pentaho.platform.api.engine.IPentahoSession,
              org.pentaho.platform.web.http.WebTemplateHelper,
              org.pentaho.platform.api.engine.IUITemplater,
        org.pentaho.platform.api.engine.IPluginManager,
              org.pentaho.platform.web.jsp.messages.Messages,
              java.util.List,
              java.util.ArrayList,
              java.util.StringTokenizer,
              org.apache.commons.lang.StringEscapeUtils,
              org.pentaho.platform.engine.core.system.PentahoSessionHolder,
              org.owasp.esapi.ESAPI,
              org.pentaho.platform.util.ServerTypeUtil"%>
  <%!
    // List of request URL strings to look for to send 401

    private List<String> send401RequestList;

    public void jspInit() {
      // super.jspInit();
      send401RequestList = new ArrayList<String>();
      String unauthList = getServletConfig().getInitParameter("send401List"); //$NON-NLS-1$
      if (unauthList == null) {
        send401RequestList.add("AdhocWebService"); //$NON-NLS-1$
      } else {
        StringTokenizer st = new StringTokenizer(unauthList, ","); //$NON-NLS-1$
        String requestStr;
        while (st.hasMoreElements()) {
          requestStr = st.nextToken();
          send401RequestList.add(requestStr.trim());
        }
      }
    }
  %>
  <%
    response.setCharacterEncoding(LocaleHelper.getSystemEncoding());
    String path = request.getContextPath();

    IPentahoSession userSession = PentahoSessionHolder.getSession();
    // SPRING_SECURITY_SAVED_REQUEST_KEY contains the URL the user originally wanted before being redirected to the login page
    // if the requested url is in the list of URLs specified in the web.xml's init-param send401List,
    // then return a 401 status now and don't show a login page (401 means not authenticated)
    Object reqObj = request.getSession().getAttribute(AbstractProcessingFilter.SPRING_SECURITY_SAVED_REQUEST_KEY);
    String requestedURL = "";
    if (reqObj != null) {
      requestedURL = ((SavedRequest) reqObj).getFullRequestUrl();

      String lookFor;
      for (int i=0; i<send401RequestList.size(); i++) {
        lookFor = send401RequestList.get(i);
        if ( requestedURL.indexOf(lookFor) >=0 ) {
          response.sendError(401);
          return;
        }
      }
    }


    boolean loggedIn = request.getRemoteUser() != null && request.getRemoteUser() != "";
    int year = (new java.util.Date()).getYear() + 1900;

    boolean showUsers = Boolean.parseBoolean(PentahoSystem.getSystemSetting("login-show-sample-users-hint", "true"));
  %>
  <!DOCTYPE html>
  <html xmlns="http://www.w3.org/1999/xhtml" class="bootstrap">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=Messages.getInstance().getString("UI.PUC.TITLE")%></title>

    <%
      String ua = request.getHeader("User-Agent").toLowerCase();
      if (!"desktop".equalsIgnoreCase(request.getParameter("mode"))) {
        if (ua.contains("ipad") || ua.contains("ipod") || ua.contains("iphone") || ua.contains("android") || "mobile".equalsIgnoreCase(request.getParameter("mode"))) {
          IPluginManager pluginManager = PentahoSystem.get(IPluginManager.class, PentahoSessionHolder.getSession());
          List<String> pluginIds = pluginManager.getRegisteredPlugins();
          for (String id : pluginIds) {
            String mobileRedirect = (String)pluginManager.getPluginSetting(id, "mobile-redirect", null);
            if (mobileRedirect != null) {
              // we have a mobile redirect
              //Check for deep linking by fetching the name and startup-url values from URL query parameters
              String name = (String) request.getAttribute("name");
              String startupUrl = (String) request.getAttribute("startup-url");
              if (startupUrl != null && name != null){
                //Sanitize the values assigned
                mobileRedirect += "?name=" + ESAPI.encoder().encodeForJavaScript(name) + "&startup-url=" + ESAPI.encoder().encodeForJavaScript(startupUrl);
              }
    %>
    <script type="text/javascript">
      if(typeof window.top.PentahoMobile != "undefined"){
        window.top.location.reload();
      } else {
        var tag = document.createElement('META');
        tag.setAttribute('HTTP-EQUIV', 'refresh');
        tag.setAttribute('CONTENT', '0;URL=<%=mobileRedirect%>');
        document.getElementsByTagName('HEAD')[0].appendChild(tag);
      }
    </script>
  </head>
  <BODY>
  <!-- this div is here for authentication detection (used by mobile, PIR, etc) -->
  <div style="display:none">j_spring_security_check</div>
  </BODY>
  </HTML>
  <%
            return;
          }
        }
      }
    }
  %>

  <meta name="gwt:property" content="locale=<%=ESAPI.encoder().encodeForHTMLAttribute(request.getLocale().toString())%>">
  <link rel="shortcut icon" href="/pentaho-style/favicon.ico" />

  <script src="content/common-ui/resources/web/jquery/jquery-1.9.1.min.js" charset="utf-8"></script>


  <style type="text/css">
      body {
    background: #e9e9e9;
    color: #666666;
    font-family: 'RobotoDraft', 'Roboto', sans-serif;
    font-size: 14px;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
  }

  /* Pen Title */
  .pen-title {
    padding: 100px 0;
    text-align: center;
    letter-spacing: 2px;
  }
  .pen-title h1 {
    margin: 0 0 20px;
    font-size: 35px;
    font-weight: 300;
  }
  .pen-title span {
    font-size: 12px;
  }
  .pen-title span .fa {
    color: #1c267d;
  }
  .pen-title span a {
    color: #1c267d;
    font-weight: 600;
    text-decoration: none;
  }

  /* Form Module */
  .form-module {
    position: relative;
    background: #ffffff;
    max-width: 450px;
    width: 100%;
    border-top: 5px solid #1c267d;
    box-shadow: 0 0 3px rgba(0, 0, 0, 0.1);
    margin: 0 auto;
  }
  .form-module .toggle {
    cursor: pointer;
    position: absolute;
    top: -0;
    right: -0;
    background: #1c267d;
    width: 30px;
    height: 30px;
    margin: -5px 0 0;
    color: #ffffff;
    font-size: 12px;
    line-height: 30px;
    text-align: center;
  }
  .form-module .toggle .tooltip {
    position: absolute;
    top: 5px;
    right: -65px;
    display: block;
    background: rgba(0, 0, 0, 0.6);
    width: auto;
    padding: 5px;
    font-size: 10px;
    line-height: 1;
    text-transform: uppercase;
  }
  .form-module .toggle .tooltip:before {
    content: '';
    position: absolute;
    top: 5px;
    left: -5px;
    display: block;
    border-top: 5px solid transparent;
    border-bottom: 5px solid transparent;
    border-right: 5px solid rgba(0, 0, 0, 0.6);
  }
  .form-module .form {
    padding: 40px;
  }
  .form-module .form:nth-child(2) {
    display: block;
  }
  .form-module h2 {
    margin: 0 0 20px;
    color: #1c267d;
    font-size: 18px;
    font-weight: 400;
    line-height: 1;
    text-align: center;
  }
  .form-module input {
    outline: none;
    display: block;
    width: 100%;
    border: 1px solid #d9d9d9;
    margin: 0 0 20px;
    padding: 10px 15px;
    box-sizing: border-box;
    font-wieght: 400;
    -webkit-transition: 0.3s ease;
    transition: 0.3s ease;
  }
  .form-module input:focus {
    border: 1px solid #1c267d;
    color: #333333;
  }
  .form-module button {
    cursor: pointer;
    background: #1c267d;
    width: 100%;
    border: 0;
    padding: 10px 15px;
    color: #ffffff;
    -webkit-transition: 0.3s ease;
    transition: 0.3s ease;
  }

  .form-module .cta {
    background: #f2f2f2;
    width: 100%;
    padding: 15px 40px;
    box-sizing: border-box;
    color: #666666;
    font-size: 12px;
    text-align: center;
  }
  .form-module .cta a {
    color: #333333;
    text-decoration: none;
  }


    </style>


  </head>

  <body>
  <div class="pen-title">
    <h1>DATAWARAHOUSE SCIM</h1>
  </div>
  <!-- Form Module-->
  <div class="module form-module">
    <div class="form">
      <h2>Iniciar sesion</h2>
      <h2 id="loginError" style="display:none; color: #cc4949; font-size: 14px;">Usuario o clave incorrecta</h2>
      <form name="login" id="login" action="j_spring_security_check" method="POST" onkeyup="if(window.event && window.event.keyCode && window.event.keyCode==13){var buttonToClick = document.getElementById('loginbtn'); if(buttonToClick){ buttonToClick.click();}}">
        <input id="j_username" name="j_username" type="text" placeholder="Usuario" autocomplete="off">
        <input id="j_password" name="j_password" type="password" placeholder="Clave" autocomplete="off">
        <button type="submit" id="loginbtn" class="btn">Entrar</button>
        <input type="hidden" name="locale" value="es">

      </form>

    </div>
  </div>



  <script type="text/javascript">


    function bounceToReturnLocation() {
      // pass
      var locale = document.login.locale.value;

      var returnLocation = '<%=ESAPI.encoder().encodeForJavaScript(requestedURL)%>';

      if (returnLocation != '' && returnLocation != null) {
        window.location.href = returnLocation;
      } else {
        window.location.href = window.location.href.replace("Login", "Home") + "?locale=" + locale;
      }

    }

    function doLogin() {

      // if we have a valid session and we attempt to login on top of it, the server
      // will actually log us out and will not log in with the supplied credentials, you must
      // login again. So instead, if they're already logged in, we bounce out of here to
      // prevent confusion.
      if (<%=loggedIn%>) {
        bounceToReturnLocation();
        return false;
      }

      jQuery.ajax({
        type: "POST",
        url: "j_spring_security_check",
        dataType: "text",
        data: $("#login").serialize(),

        error:function (xhr, ajaxOptions, thrownError){
          if (xhr.status == 404) {
            // if we get a 404 it means login was successful but intended resource does not exist
            // just let it go - let the user get the 404
            bounceToReturnLocation();
            return;
          }
          //Fix for BISERVER-7525
          //parsereerror caused by attempting to serve a complex document like a prd report in any presentation format like a .ppt
          //does not necesarly mean that there was a failure in the login process, status is 200 so just let it serve the archive to the web browser.
          if (xhr.status == 200 && thrownError == 'parsererror') {
            document.getElementById("j_password").value = "";
            bounceToReturnLocation();
            return;
          }
          // fail
          $("#loginError").show();
        },

        success:function(data, textStatus, jqXHR){
          if (data.indexOf("j_spring_security_check") != -1) {
            // fail
            $("#loginError").show();
            $("#loginError button").focus();
            return false;
          } else {
            document.getElementById("j_password").value = "";
            bounceToReturnLocation();
          }
        }
      });
      return false;
    }



    $(document).ready(function(){
      $("#login").submit(doLogin);

      if (<%=loggedIn%>) {
        bounceToReturnLocation();
      }

      $("#j_username").focus();


    });
  </script>
  </body>
