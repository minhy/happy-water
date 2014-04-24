<cfquery name="qCategory" >
    SELECT * FROM category
</cfquery>


    <cfparam name="FORM.categoryID" type="integer" default="0"/>
    <cfparam name="FORM.parent" type="integer" default="0"/>
    <cfparam name="URL.categoryID"  type="integer" default="0">
    <cfparam name="FORM.image" type="string" default=""/>

    <cfparam name="Validation.categoryName.text" default="&nbsp"/>
    <cfparam name="Validation.categoryName.class" default=""/>
    <cfparam name="Validation.parentID.text" default="&nbsp"/>
    <cfparam name="Validation.parentID.class" default=""/>
    <cfparam name="Validation.image.class" default=""/>
    <cfparam name="Validation.image.text" default="&nbsp"/>
    <cfparam name="Validation.status.class" default=""/>
    <cfparam name="Validation.status.text" default="&nbsp"/>
    <cfparam name="Validation.IsActive.class" default=""/>
    <cfparam name="Validation.IsActive.text" default="&nbsp"/>
    <cfparam name="Validation.tag.class" default=""/>
    <cfparam name="Validation.tag.text" default="&nbsp"/>

    <cfparam name="Validation.Valid" default="true"/>

    <cfset InvalidClass = "label label-warning"/>


<cfif FORM.categoryID GT 0 OR URL.categoryID GT 0>
    <cfset FormMode = "edit"/>
<cfelse>
    <cfset FormMode = "insert"/>
</cfif>
<!--- lab8.1 step2 --->
<!--- set handler action --->
<cfif CGI.REQUEST_METHOD EQ 'get' AND URL.categoryID EQ 0>
    <cfset FormAction   = "show"/>
<cfelseif CGI.REQUEST_METHOD EQ 'get' AND URL.categoryID GT 0>
    <cfset FormAction = "edit"/>
<cfelseif CGI.REQUEST_METHOD EQ 'post' AND FORM.categoryID GT 0>
    <cfset FormAction = "update"/>
<cfelse>
    <cfset FormAction = "insert"/>
</cfif> 

<cfswitch expression="#FormAction#">
    <cfcase value="show">
        <cfparam name="FORM.categoryName" type="string" default=""/>
        <cfparam name="FORM.parentID" type="string" default="0"/>
        <cfparam name="FORM.status" type="string" default="0"/>
        <cfparam name="FORM.IsActive" type="string" default="0"/>
        <cfparam name="FORM.image" type="string" default=""/>
        <cfparam name="FORM.tag" type="string" default=""/>
    </cfcase>

    <cfcase value="edit">

        <cfquery name="qEdit">      
            SELECT *
            FROM category
            WHERE categoryID = <cfqueryparam sqltype="integer" value="#URL.categoryID#"/>
        </cfquery>

        <cfset FORM.categoryID = qEdit.categoryID/>
        <cfset FORM.categoryName = qEdit.categoryName/>
        <cfset FORM.parent = qEdit.parentID/>
        <cfset FORM.IsActive = qEdit.IsActive/>
        <cfset FORM.status = qEdit.status/>
        <cfset FORM.image =qEdit.image/>
        <cfset FORM.tag = qEdit.tag/>

        <cfquery name="qParent">      
            SELECT *
            FROM category
            WHERE categoryID = <cfqueryparam sqltype="integer" value="#FORM.parent#"/>
        </cfquery>

    </cfcase>

    <cfcase value="insert">
        <cfif isDefined("FORM.image")>
            <cfif FORM.image is not "">
                <cffile action = "upload" 
                        nameconflict = "unique" 
                        result="Reupload"
                        fileField = "image"
                        destination = "/images/category/">
            </cfif>
        </cfif>
            <!--- lab 7.1 step3 --->
            <cfif NOT IsDefined('FORM.categoryName') OR Len(Trim(FORM.categoryName)) GT 255 OR Len(Trim(FORM.categoryName)) EQ 0>
                <cfset Validation.categoryName.text = "Please provide a title with maximal 255 characters."/>
                <cfset Validation.categoryName.class = InvalidClass/>
                <cfset Validation.Valid = false/>
            </cfif>
            <cfif NOT IsDefined('FORM.image') OR FORM.image EQ "">
                <cfset Validation.image.text = "Please choose an image."/>
                <cfset Validation.image.class = InvalidClass/>
                <cfset Validation.Valid = false/>
            </cfif>
            
            <!--- lab7.1 step4 --->
            <cfif Validation.Valid>
            
                <cftransaction isolation="serializable" action="begin">
                    <cftry>

                        <cfquery name="insert_category" result="Result">
                            INSERT INTO `happy_water`.`category` 
                            (
                                `categoryName`,
                                `parentID`,
                                `image`,
                                `status`,
                                `IsActive`,
                                `tag`
                            ) 
                            VALUES
                            (
                                <cfqueryparam sqltype="varchar" value="#FORM.categoryName#"/>,
                                <cfqueryparam sqltype="varchar" value="#FORM.parentID#"/>,
                                <cfqueryparam sqltype="varchar" value="/images/category/#Reupload.clientfile#"/>,
                                <cfqueryparam sqltype="bit" value="#FORM.status#"/>,
                                <cfqueryparam sqltype="bit" value="#FORM.IsActive#"/>,
                                <cfqueryparam sqltype="varchar" value="#FORM.tag#"/>   
                            )
                        </cfquery>
                        
                           
                        
                        <cftransaction action="commit"/>
                        <cfcatch>
                            <cftransaction action="rollback"/>
                                <!--- <cfdump var="#cfcatch#"> --->
                        </cfcatch>

                    </cftry>
                </cftransaction>
                <!--- lab7.1 step4 --->
                <cflocation url="#buildUrl('category.default')#"/>
            </cfif>
    </cfcase>

    <cfcase value="update">
        <cfif isDefined("FORM.image")>
            <cfif FORM.image is not "">
                <cffile action = "upload" 
                        nameconflict = "unique" 
                        result="Reupload"
                        fileField = "image"
                        destination = "/images/category/">
            </cfif>
        </cfif>
        <cfif NOT IsDefined('FORM.categoryName') OR Len(Trim(FORM.categoryName)) GT 255 OR Len(Trim(FORM.categoryName)) EQ 0>
                <cfset Validation.categoryName.text = "Please provide a title with maximal 255 characters."/>
                <cfset Validation.categoryName.class = InvalidClass/>
                <cfset Validation.Valid = false/>
            </cfif>
        <cfif NOT IsDefined('FORM.image') OR FORM.image EQ "">
            <cfset Validation.image.text = "Please choose an image."/>
            <cfset Validation.image.class = InvalidClass/>
            <cfset Validation.Valid = false/>
        </cfif>
        <cfif Validation.Valid>
            <cftransaction isolation="serializable" action="begin">
                <cftry>

                    <cfquery name="update_category" result="Result">

        UPDATE `category`
        SET 
            `categoryName` = <cfqueryparam sqltype="varchar" value="#FORM.categoryName#"/>,
            `parentID` = <cfqueryparam sqltype="varchar" value="#FORM.parentID#"/>
            <cfif FORM.image is not "">
            ,`image` = <cfqueryparam sqltype="varchar" value="/images/category/#Reupload.clientfile#"/>
            </cfif>,
            `status` = <cfqueryparam sqltype="bit" value="#FORM.status#"/>,
            `IsActive` = <cfqueryparam sqltype="bit" value="#FORM.IsActive#"/>,
            `tag` = <cfqueryparam sqltype="varchar" value="#FORM.tag#"/>
            
        WHERE `categoryID` = <cfqueryparam sqltype="integer" value="#FORM.categoryID#"/>
                    </cfquery>
                    <cftransaction action="commit"/>
                <cfcatch>
                    <cftransaction action="rollback"/>
                </cfcatch>
                </cftry>
            </cftransaction>
            <cflocation url="#buildUrl('category.default')#"/>
        </cfif>
    </cfcase>
</cfswitch>


<script type="text/javascript" language="javascript">
        $("document").ready(function(){

            function readURL(input) {

                if (input.files && input.files[0]) {
                    var reader = new FileReader();

                    reader.onload = function (e) {
                        $('#currentImage').attr('src', e.target.result);
                    }

                    reader.readAsDataURL(input.files[0]);
                }
            } 
            $("#image").change(function() {
                             readURL(this);
                        });
    $("#selectParentID").change(function(){
        $("#parentID").val($("#selectParentID").val());
    });
        });       
</script>
<cfoutput>
    <div class="container wrap main">
        <section class="main-container">
            <!-- Master Page -->
        <div style="width:500px; margin:auto">
            <div class="row clearfix">
                <div class="col-md-12 column">

                    <cfif NOT Validation.Valid>
                    <div class="warning">
                        <h3>Could not save news category</h3>
                    </div>
                    </cfif>


                    <form method="post"  enctype="multipart/form-data">
                        <input type="hidden" id="categoryID" name="categoryID" value="#FORM.categoryID#"/>

                        <input type="hidden" id="parentID" name="parentID" value="#FORM.parent#"/>

                        <!---Name --->
                        <label for="categoryName">Category Name</label>
                        <div class="#Validation.categoryName.class#">
                            #Validation.categoryName.text#
                        </div>
                        <div class="form-group">
                             <input type="text" class="form-control" id="categoryName" name="categoryName" validate="regex" pattern="[A-Z a-z 0-9]{1,20}" value="#FORM.categoryName#"/>
                        </div>

                        <!---Parent --->
                        <label for="parentID">Parent</label>
                        <div class="#Validation.parentID.class#">
                            #Validation.parentID.text#
                        </div>
                        <div class="form-group">
                             <select id="selectParentID">
                                <cfloop query="qCategory"> 
                                    <cfif FORM.parent EQ qCategory.CategoryID>
                                      <cfset IsSelected = "selected" >
                                    <cfelse>       
                                        <cfset IsSelected = "" >
                                    </cfif>
                                                              
                                    <option #isSelected# value="#qCategory.categoryID#">#qCategory.categoryName#</option>
                                </cfloop>
                            </select>
                        </div>

                        <!--- Is Active --->
                         <label for="IsActive">Active</label>
                        <div class="#Validation.IsActive.class#">
                            #Validation.IsActive.text#
                        </div>
                        <div class="form-group">
                             <p class="input-group-addon">
                                <input type="radio" id="IsActive" name="IsActive" value="0" <cfif NOT FORM.IsActive> checked</cfif>> Not selling
                             </p>
                             <p class="input-group-addon">
                                <input type="radio" id="IsActive" name="IsActive" value="1" <cfif FORM.IsActive> checked</cfif>> Selling
                             </p>
                        </div>

                        <!--- Status --->
                        <label for="status">Status</label>
                        <div class="#Validation.status.class#">
                            #Validation.status.text#
                        </div>
                        <div class="form-group">
                             <p class="input-group-addon">
                                <input type="radio" id="status" name="status" value="0" <cfif NOT FORM.status> checked</cfif>> Out of stock
                             </p>
                             <p class="input-group-addon">
                                <input type="radio" id="status" name="status" value="1" <cfif FORM.status> checked</cfif>> In stock
                             </p>
                        </div>
                     
                        <!---- Image ---->
                        <label for="image">Choose an image</label>
                        <div class="#Validation.image.class#">
                            #Validation.image.text#
                        </div>
                        <div class="form-group">
                            <input type="file" name="image" id="image" value="#FORM.image#"/>
                        </div>
                        <label for="image">Current image</label>
                        <div class="form-group">
                            <img id="currentImage" src="#FORM.image#" alt="hinh" width="144" height="144">
                        </div>

                        <!---Tag --->
                        <label for="tag">Tag</label>
                        <div class="#Validation.tag.class#">
                            #Validation.tag.text#
                        </div>
                        <div class="form-group">
                             <input type="text" class="form-control" id="tag" name="tag" <!--- validate="regex" pattern="[A-Za-z]{1,20}" ---> value="#FORM.tag#"/>
                        </div>

                        <!--Submit-->
                        <div class="div_center">
                            <button type="submit" class="btn btn-default btn_center">Submit</button>
                        </div>
                    </form>
                    
                </div>
            </div>
        </div> 
        <cfdump eval=form>
        <cfdump eval="qCategory">
        <cfdump eval="#URL.categoryID#">
        <cfdump eval=formaction> 
        <cfdump var="#getContextRoot()#">
            <!-- END Master Page -->
        </section>
    </div>
</cfoutput>
