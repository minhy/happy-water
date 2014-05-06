<cfquery name="qCategory" >
    SELECT * FROM category
</cfquery>


    <cfparam name="FORM.categoryID" type="integer" default="0"/>
    <cfparam name="FORM.parent" type="integer" default="0"/>
     <cfparam name="FORM.parentID" type="integer" default="0"/>
    <cfparam name="URL.categoryID"  type="integer" default="0">
    <cfparam name="FORM.image" type="string" default=""/>


    <cfparam name="Validation.categoryName.text" default="&nbsp"/>
    <cfparam name="Validation.categoryName.class" default=""/>
    <cfparam name="Validation.description.text" default="&nbsp"/>
    <cfparam name="Validation.description.class" default=""/>
    <cfparam name="Validation.parentID.text" default="&nbsp"/>
    <cfparam name="Validation.parentID.class" default=""/>
    <cfparam name="Validation.image.class" default=""/>
    <cfparam name="Validation.image.text" default="&nbsp"/>
   <!---  <cfparam name="Validation.status.class" default=""/>
    <cfparam name="Validation.status.text" default="&nbsp"/> --->
    <cfparam name="Validation.IsActive.class" default=""/>
    <cfparam name="Validation.IsActive.text" default="&nbsp"/>
    <!--- <cfparam name="Validation.tag.class" default=""/>
    <cfparam name="Validation.tag.text" default="&nbsp"/> --->

    <cfparam name="Validation.Valid" default="true"/>

    <cfset InvalidClass = "label label-warning"/>

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
        <cfparam name="FORM.description" type="string" default=""/>
        <cfparam name="FORM.parentID" type="string" default=""/>
        <!--- <cfparam name="FORM.status" type="string" default="0"/> --->
        <cfparam name="FORM.IsActive" type="string" default="0"/>
        <cfparam name="FORM.image" type="string" default=""/>
        <!--- <cfparam name="FORM.tag" type="string" default=""/> --->
    </cfcase>

    <cfcase value="edit">

        <cfquery name="qGetCategoryByID">      
            SELECT *
            FROM category
            WHERE categoryID = <cfqueryparam sqltype="integer" value="#URL.categoryID#"/>
        </cfquery>

        <cfset FORM.categoryID = qGetCategoryByID.categoryID/>
        <cfset FORM.categoryName = qGetCategoryByID.categoryName/>
        <cfset FORM.description = qGetCategoryByID.description/>
        <cfset FORM.parent = qGetCategoryByID.parentID/>
        <cfset FORM.IsActive = qGetCategoryByID.IsActive/>
        <!--- <cfset FORM.status = qGetCategoryByID.status/> --->
        <cfset FORM.image =qGetCategoryByID.image/>
        <!--- <cfset FORM.tag = qGetCategoryByID.tag/> --->

        <cfquery name="qGetCategoryParentByID">      
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
       
            <cfif NOT IsDefined('FORM.categoryName') OR Len(Trim(FORM.categoryName)) GT 255 OR Len(Trim(FORM.categoryName)) EQ 0>
                <cfset Validation.categoryName.text = "Please provide a title with maximal 255 characters."/>
                <cfset Validation.categoryName.class = InvalidClass/>
                <cfset Validation.Valid = false/>
            </cfif>
            <cfif NOT IsDefined('FORM.description') OR Len(Trim(FORM.description)) GT 255 OR Len(Trim(FORM.description)) EQ 0>
                <cfset Validation.description.text = "Please provide a description with maximal 255 characters."/>
                <cfset Validation.description.class = InvalidClass/>
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
                         <cfquery name="qInsertCategory" result="Result">
                            INSERT INTO `category` 
                            (
                                `categoryName`,
                                `description`,
                                `parentID`,
                                `image`,                       
                                `IsActive`
                            ) 
                            VALUES
                            (
                                <cfqueryparam sqltype="varchar" value="#FORM.categoryName#"/>,
                                <cfqueryparam sqltype="varchar" value="#FORM.description#"/>,
                                <cfqueryparam sqltype="varchar" value="#FORM.parentID#"/>,
                                <cfqueryparam sqltype="varchar" value="/images/category/#Reupload.clientfile#"/>,
                                <cfqueryparam sqltype="bit" value="#FORM.IsActive#"/>  
                            )
                        </cfquery>
                        <cftransaction action="commit"/>
                        <cfcatch>
                            <cftransaction action="rollback"/>
                                <!--- <cfdump var="#cfcatch#"> --->
                        </cfcatch>
                    </cftry>
                </cftransaction>
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
        <cfif NOT IsDefined('FORM.description') OR Len(Trim(FORM.description)) GT 255 OR Len(Trim(FORM.description)) EQ 0>
            <cfset Validation.description.text = "Please provide a description with maximal 255 characters."/>
            <cfset Validation.description.class = InvalidClass/>
            <cfset Validation.Valid = false/>
        </cfif>
     <!---    <cfif NOT IsDefined('FORM.image') OR FORM.image EQ "">
            <cfset Validation.image.text = "Please choose an image."/>
            <cfset Validation.image.class = InvalidClass/>
            <cfset Validation.Valid = false/>
        </cfif> --->
        <cfif Validation.Valid>
        <cftransaction isolation="serializable" action="begin">
            <cftry>

                <cfquery name="qUpdateCategory" result="Result">
                    UPDATE `category`
                    SET 
                        `categoryName` = <cfqueryparam sqltype="varchar" value="#FORM.categoryName#"/>,
                        `description` = <cfqueryparam sqltype="varchar" value="#FORM.description#"/>,
                        `parentID` = <cfqueryparam sqltype="varchar" value="#FORM.parentID#"/>
                        <cfif FORM.image is not "">
                        ,`image` = <cfqueryparam sqltype="varchar" value="/images/category/#Reupload.clientfile#"/>
                        </cfif>,
                        `IsActive` = <cfqueryparam sqltype="bit" value="#FORM.IsActive#"/>
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
  
        });       
</script>
<cfoutput>
    <legend><h1>Category Management - Updater</h1></legend>
    <div style="width:600px; margin:auto">
        <div class="row clearfix">
            <div class="col-md-12 column">

                <cfif NOT Validation.Valid>
                <div class="warning">
                    <h3>Could not save news category</h3>
                </div>
                </cfif>

                <form method="post"  enctype="multipart/form-data">
                    <input type="hidden" id="categoryID" name="categoryID" value="#FORM.categoryID#"/>
                    <input type="hidden" id="parent" name="parent" value="#FORM.ParentID#"/>

                    <!---Name --->
                    <label for="categoryName">Category Name</label>
                    <div class="#Validation.categoryName.class#">
                        #Validation.categoryName.text#
                    </div>
                    <div class="form-group">
                         <input type="text" class="form-control" id="categoryName" name="categoryName" validate="regex" pattern="[A-Z a-z 0-9]{1,20}" value="#FORM.categoryName#"/>
                    </div>

                    <!--- Description --->
                    <label for="description">Description</label>
                    <div class="#Validation.description.class#">
                        #Validation.description.text#
                    </div>
                    <div class="form-group">
                         <textarea type="text" required="yes" class="form-control" id="description" name="description">#FORM.description#</textarea>
                    </div>

                    <!---Parent --->
                    <label for="parentID">Parent</label>
                    <div class="#Validation.parentID.class#">
                        #Validation.parentID.text#
                    </div>
                    <div class="form-group">
                         <select id="ParentID" name="ParentID">
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
                        <img id="currentImage" src="#FORM.image#" alt="No Image" width="144" height="144">
                    </div>
                    <!--Submit-->
                    <div class="div_center">
                        <button type="submit" class="btn btn-default btn_center">Submit</button>
                    </div>
                </form>
                
            </div>
        </div>
    </div> 
</cfoutput>
