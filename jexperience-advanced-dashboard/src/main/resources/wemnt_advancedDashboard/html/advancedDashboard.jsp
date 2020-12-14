<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="user" uri="http://www.jahia.org/tags/user" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<template:addResources>
    <script type="application/javascript">
        (function () {
            $(document).ready(function () {
                $('#dashboardFrame').attr('src', $('.selectDashboard').val());
                var selectedDashboardUrl = $('.selectDashboard option:selected').val();
                selectedDashboardUrl = selectedDashboardUrl.replace(/now-([1-9]|[12][0-9]|3[01])d/, "now-1d");
                $('#kibana1d').attr('href', selectedDashboardUrl);
                selectedDashboardUrl = selectedDashboardUrl.replace(/now-([1-9]|[12][0-9]|3[01])d/, "now-7d");
                $('#kibana7d').attr('href', selectedDashboardUrl);
                selectedDashboardUrl = selectedDashboardUrl.replace(/now-([1-9]|[12][0-9]|3[01])d/, "now-30d");
                $('#kibana30d').attr('href', selectedDashboardUrl);

                $('.selectDashboard').change(function () {
                    var selectedDashboardUrl = $(this).val();
                    $('#dashboardFrame').attr('src', selectedDashboardUrl);
                    selectedDashboardUrl = selectedDashboardUrl.replace(/now-([1-9]|[12][0-9]|3[01])d/, "now-1d");
                    $('#kibana1d').attr('href', selectedDashboardUrl);
                    selectedDashboardUrl = selectedDashboardUrl.replace(/now-([1-9]|[12][0-9]|3[01])d/, "now-7d");
                    $('#kibana7d').attr('href', selectedDashboardUrl);
                    selectedDashboardUrl = selectedDashboardUrl.replace(/now-([1-9]|[12][0-9]|3[01])d/, "now-30d");
                    $('#kibana31d').attr('href', selectedDashboardUrl);
                });
                $('#kibana1d').click(function (e) {
                    e.preventDefault();
                    var selectedDashboardUrl = $(this).attr('href');
                    $('#dashboardFrame').attr('src', selectedDashboardUrl);
                });
                $('#kibana7d').click(function (e) {
                    e.preventDefault();
                    var selectedDashboardUrl = $(this).attr('href');
                    $('#dashboardFrame').attr('src', selectedDashboardUrl);
                });
                $('#kibana31d').click(function (e) {
                    e.preventDefault();
                    var selectedDashboardUrl = $(this).attr('href');
                    $('#dashboardFrame').attr('src', selectedDashboardUrl);
                });
            });
        })();
    </script>
</template:addResources>
<jcr:sql var="result"
         sql="SELECT * FROM [wemnt:kibanaConfig] AS kibanaConfig WHERE ISDESCENDANTNODE(kibanaConfig, '${renderContext.site.path}')"/>
<c:if test="${result.nodes != null && result.nodes.size > 0}">
    <div style="margin-bottom:-5px;">
    <header class="wem-page-head">
        <div class="headerTitle">
            <img style="vertical-align: middle;margin-right:10px;"
                 src="/files/default/modules/jexperience/1.12.2/templates/files/icons_product_MF.png" height="18px"
                 width="18px"><fmt:message
                key="label.advancedDashboard"/>
        </div>
        <div class="headerFilters">
            <div class="form-group">
                Dashboard:&nbsp;
                <select name="selectedDashboard" class="selectDashboard form-control"
                        style="min-width: 250px; margin-left: 10px">
                    <c:forEach var="node" items="${result.nodes}" varStatus="theCount">
                        <jcr:nodeProperty node="${node}" name="kibanaUrl" var="kibanaUrl"/>
                        <c:if test="${node.displayableName eq 'Site Activity'}">
                            <option selected
                                    value="${fn:replace(kibanaUrl, '${site}', renderContext.site.name)}">${node.displayableName}</option>
                        </c:if>
                        <c:if test="${node.displayableName ne 'Site Activity'}">
                            <option value="${fn:replace(kibanaUrl, '${site}', renderContext.site.name)}">${node.displayableName}</option>
                        </c:if>
                    </c:forEach>
                </select>
                <div style="margin-left:5px; padding-left:5px;padding-right:5px;display:inline-block">
                <a style="text-decoration: none;" href="" title="Today" id="kibana1d">
                    <img height="35px" width="35px" src="<c:url value="${url.currentModule}/img/calendar-1.png"/>"
                         alt="Today">
                </a>
                <a style="text-decoration: none;" href="" id="kibana7d">
                    <img height="35px" width="35px" src="<c:url value="${url.currentModule}/img/calendar-7.png"/>"
                         alt="This Week">
                </a>
                <a style="text-decoration: none;" href="" title="This Month" id="kibana31d">
                    <img height="35px" width="35px" src="<c:url value="${url.currentModule}/img/calendar-31.png"/>"
                         alt="This Month">
                </a>
                </div>
            </div>
        </div>
    </header>
    <div style="display: inline-block">
        <iframe id="dashboardFrame" frameborder="0"
                style="overflow: hidden; height: 100%; width: 100%; position: absolute;"></iframe>
    </div>
</c:if>
<c:if test="${result.nodes != null && result.nodes.size == 0}">
    <div class="warning-message"><fmt:message key="label.noDashboardFound"/></div>
</c:if>
<template:addResources type="css" resources="advanced-dashboard.css"/>
<template:theme/>