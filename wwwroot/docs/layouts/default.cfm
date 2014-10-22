<!doctype html>
<html>
	<head>
		<title>API Docs</title>
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap-theme.min.css">

		<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
		<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
		<!--[if lt IE 9]>
		<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
		<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
		<![endif]-->
	</head>
	<body>
		<div class="container">
			<header class='col-xs-12'>
				<h1>API Docs</h1>
			</header>

			<section class='col-xs-12 col-sm-3 col-md-4'>
				<h2>Documents</h2>
				<section class='panel panel-default'>
					<div class="panel-heading text-capitalize">
						<h3 class="panel-title">Navigation</h3>
					</div>
					<ul class="list-group">
						<li class="list-group-item"><a href='/docs/'>Home</a></li>
					</ul>
				</section>
				<cfoutput>#view('main/filelist')#</cfoutput>
			</section>
			<section class='col-xs-12 col-sm-9 col-md-8'>
				<cfoutput>#body#</cfoutput>
			</section>
		</div>

		<script src="//code.jquery.com/jquery-1.11.0.min.js"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
	</body>
</html>