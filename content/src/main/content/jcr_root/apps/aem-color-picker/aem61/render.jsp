<%@include file="/libs/granite/ui/global.jsp" %><%
%><%@page session="false"
          import="com.adobe.granite.ui.components.AttrBuilder,
                  com.adobe.granite.ui.components.Config,
                  com.adobe.granite.ui.components.Field,
                  com.adobe.granite.ui.components.Tag" %><%--###
TextField
=========

.. granite:servercomponent:: /apps/aem-color-picker/aem61
   :supertype: /libs/granite/ui/components/foundation/form/field
   
   A text field component.

   It extends :granite:servercomponent:`Field </libs/granite/ui/components/foundation/form/field>` component.

   It has the following content structure:

   .. gnd:gnd::

      [granite:FormTextField] > granite:commonAttrs
      
      /**
       * The name that identifies the field when submitting the form.
       */
      - name (String)
      
      /**
       * The value of the field.
       */
      - value (StringEL)
      
      /**
       * A hint to the user of what can be entered in the field.
       */
      - emptyText (String) i18n
      
      /**
       * Indicates if the field is in disabled state.
       */
      - disabled (Boolean)
      
      /**
       * Indicates if the field is mandatory to be filled.
       */
      - required (Boolean)
###--%><%

    Config cfg = cmp.getConfig();
    ValueMap vm = (ValueMap) request.getAttribute(Field.class.getName());
    Field field = new Field(cfg);

    boolean isMixed = field.isMixed(cmp.getValue());
    
    Tag tag = cmp.consumeTag();
    AttrBuilder attrs = tag.getAttrs();
    cmp.populateCommonAttrs(attrs);

    // Start of attrs compatibility; please use cmp.populateCommonAttrs(attrs).
    attrs.add("id", cfg.get("id", String.class));
    attrs.addClass(cfg.get("class", String.class));
    attrs.addRel(cfg.get("rel", String.class));
    attrs.add("title", i18n.getVar(cfg.get("title", String.class)));
    attrs.addOthers(cfg.getProperties(), "id", "class", "rel", "title", "type", "name", "value", "emptyText", "disabled", "required", "maxlength", "fieldLabel", "fieldDescription", "renderReadOnly", "ignoreData");
    // End of attrs compatibility.
    
    attrs.add("type", "text");
    String name = cfg.get("name", String.class);
    attrs.add("name", name);
    attrs.add("placeholder", i18n.getVar(cfg.get("emptyText", String.class)));
    attrs.addDisabled(cfg.get("disabled", false));

    if (isMixed) {
        attrs.addClass("foundation-field-mixed");
        attrs.add("placeholder", i18n.get("<Mixed Entries>"));
    } else {
        attrs.add("value", vm.get("value", String.class));
    }


    if (cfg.get("required", false)) {
        attrs.add("aria-required", true);
    }

    attrs.addClass("coral-Textfield");
    attrs.addClass("js-color-picker");
    
%><input <%= attrs.build() %> />

<%--### lazy load the clientlib, this will be cached by browser (unless caching is disabled ###--%>
<ui:includeClientLib categories="aem.color-picker"/>
<script>
(function(){
    // waits for jquery plugin to become available
    function waitFor(i,e,t){if(window.$.fn[i]){t()}else if(e<=0){return}else{setTimeout(function(){waitFor(i,e-150,t)},150)}};
    var $picker = $('.js-color-picker[name="<%=name%>"]');
    $picker.attr('disabled', 'disabled') // disable picker
    waitFor('tinyColorPicker', 1000*30, function(){
        $picker.tinyColorPicker({
            renderCallback:function(){
                this.$UI.css('z-index','9999999');
            }
        });
        $picker.removeAttr('disabled') // enable picker
    });
})();
</script>