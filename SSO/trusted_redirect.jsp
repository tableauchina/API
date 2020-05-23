<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*"%>
<%@ page import="java.net.URL"%> 
<%@ page import="java.net.URLConnection"%> 
<%@ page import="java.net.URLEncoder"%> 
<html>
<head>
	<meta name="author" content="mling@tableau.com">
    <title>Tableau Sample</title>
	<script type="text/javascript">
	</script>
</head>
<body >
	<%
            String ticket="";
            OutputStreamWriter out1 = null;
            BufferedReader in = null;
            try {
                //构造请求认证ticket参数,用户名和所要访问的站点信息,如代码里admin是用户名,testsite是站点ID
                StringBuffer data = new StringBuffer();
                data.append(URLEncoder.encode("username", "UTF-8"));
                data.append("=");
                data.append(URLEncoder.encode("admin", "UTF-8"));
                data.append("&");
                data.append(URLEncoder.encode("target_site", "UTF-8"));
                data.append("=");
                data.append(URLEncoder.encode("testsite", "UTF-8"));

                //发送请求到Tableau Server的服务器地址获取ticket
                URL url = new URL("http://tableauserver/trusted");
                URLConnection conn = url.openConnection();
                conn.setDoOutput(true);
                out1 = new OutputStreamWriter(conn.getOutputStream());
                out1.write(data.toString());
                out1.flush();

                // 接收返回的ticket信息
                StringBuffer rsp = new StringBuffer();
                in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                String line;
                while ( (line = in.readLine()) != null) {
                    rsp.append(line);
                }
                ticket=rsp.toString();
            } catch (Exception e) {
                throw new ServletException(e);
            }
            //拼接出含有认证ticket的报表URL地址
            String redirectrepurl="http://tableauserver/trusted/"+ticket+"/t/testsite/views/KPI/sheet0?:embed=y&:showAppBanner=false&:display_count=no&:showVizHome=no";
            //跳转并打开工作表
            response.sendRedirect(redirectrepurl);
            //关于工作表URL构造和参数传递可以参考下面的文档哦
            //https://help.tableau.com/current/pro/desktop/zh-cn/embed_structure.htm
            //https://help.tableau.com/current/pro/desktop/zh-cn/embed_list.htm
%>

</body>
</html>