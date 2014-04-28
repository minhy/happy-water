
<cfquery name="qGetMenuBottom">
	SELECT * 
	FROM menu 
	WHERE menu_tag = "bottom"
	AND menu_isactive = 1
</cfquery>
<cfoutput>
<section id="bottom">
	<div class="row clearfix">
		<div class="col-md-4 column line-right">
			<h6>FOLLOW US</h6>
			<p>Sign up to receive our weekly newsletter</p>
			<form>
			<div class="input-group">
			  <input type="text" class="form-control " placeholder="Your email address">
			  <span class="input-group-btn">
		        <button class="btn btn-default" type="button">JOIN</button>
		      </span>
			</div>
			</form>
		</div>
		<div class="col-md-4 column line-right">
			<div class="row clearfix">
				<div class="col-md-12 column">
					<ul class="nav nav-pills">
						<cfloop query="qGetMenuBottom">
							<li>
								<a href = "#getContextRoot()#/#qGetMenuBottom.menu_link#">#qGetMenuBottom.menu_name#</a>
							</li>
						</cfloop>

					</ul>

				</div>
			</div>
		</div>
		<div class="col-md-4 column">
			<p><img src="#getContextRoot()#/home/images/paypal_1.jpg" width="80" height="40"></p>
			<p><img src="#getContextRoot()#/home/images/vseal.gif" width="80" height="40"></p>
		</div>
	</div>
</section>
</cfoutput>