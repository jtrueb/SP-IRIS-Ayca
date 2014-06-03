function GUI_makeGUI_SliderAndTxtBox(hTabGroup,strName,strLongName,strName2,minV,maxV,val,height1,handlesSld,handlesText)
heightval = 0.03;
heightvaltext = 0.03;
heightoffsettext = 0.00;
width1 = 0.02;
width2 = 0.25;
width3 = 0.40;
width4 = 0.2;
left1 = 0.01;
left2 = left1+width1+0.02;
left3 = left2+width2+0.02;
left4 = left3+width3+0.02;
height2 = height1+heightval;
height3 = height2+heightval;
fontSize1 = 8;
fontSize2 = 8;
fontSize3 = 8;

[color] =  GUI_Colors();


txtDataType = uicontrol(hTabGroup,'Style','text',...
                'Tag',['txtDatatype_' strName],...
                'String',strLongName,'Units','normalized',...
                'HorizontalAlignment','Left',...
                'BackgroundColor',color.bgc{2},...
                'FontSize',fontSize2,...
                'Position',[left2 height3 width2+width3+width4 heightval]);  
            
sld = uicontrol(hTabGroup,'Style','slider',...
                'Tag',['sld' strName],...
                'Callback',handlesSld,...
                'Min',minV,...
                'Max',maxV,...
                'Value',val,...
                'BackgroundColor',color.bgc{2},...
                'Units','normalized',...
                'HorizontalAlignment','Left',...
                'Position',[left3 height2 width3 heightval]);              

editValue = uicontrol(hTabGroup,'Style','edit',...
                'Tag',['edit' strName],...
                'Callback',handlesText,...
                'BackgroundColor',color.bgc{2},...
                'String',num2str(val),'Units','normalized',...
                'HorizontalAlignment','Left',...
                'FontSize',fontSize1,...
                'Position',[left4 height2+heightoffsettext width4 heightvaltext]);                
            
txtUnits = uicontrol(hTabGroup,'Style','text',...
                'Tag',['txtUnits' strName],...
                'String',strName2,'Units','normalized',...
                'HorizontalAlignment','Left',...
                'BackgroundColor',color.bgc{2},...
                'FontSize',fontSize3,...
                'Position',[left2 height2 width2 heightval]);  
