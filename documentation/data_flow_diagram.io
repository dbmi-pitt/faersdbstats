<mxfile host="app.diagrams.net" modified="2024-11-19T15:46:26.522Z" agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" etag="ksdmLJm5E8yiGqYpK5lA" version="24.4.4" type="device">
  <diagram id="prtHgNgQTEPvFCAcTncT" name="Page-1">
    <mxGraphModel dx="1434" dy="772" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1169" pageHeight="827" math="0" shadow="0">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />
        <mxCell id="BxyisJofKgbbL4D_qTQu-10" value="" style="rounded=0;whiteSpace=wrap;html=1;" vertex="1" parent="1">
          <mxGeometry x="50" y="380" width="1080" height="250" as="geometry" />
        </mxCell>
        <mxCell id="BxyisJofKgbbL4D_qTQu-1" value="FDA" style="rounded=0;whiteSpace=wrap;html=1;" vertex="1" parent="1">
          <mxGeometry x="90" y="190" width="120" height="70" as="geometry" />
        </mxCell>
        <mxCell id="BxyisJofKgbbL4D_qTQu-2" value="" style="rounded=0;whiteSpace=wrap;html=1;" vertex="1" parent="1">
          <mxGeometry x="250" y="190" width="870" height="100" as="geometry" />
        </mxCell>
        <mxCell id="BxyisJofKgbbL4D_qTQu-3" value="FAERSDBSTATS ETL SERVER" style="rounded=0;whiteSpace=wrap;html=1;" vertex="1" parent="1">
          <mxGeometry x="485" y="580" width="200" height="30" as="geometry" />
        </mxCell>
        <mxCell id="BxyisJofKgbbL4D_qTQu-14" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0.75;exitY=0;exitDx=0;exitDy=0;" edge="1" parent="1" source="BxyisJofKgbbL4D_qTQu-4" target="BxyisJofKgbbL4D_qTQu-15">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="370" y="310" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="BxyisJofKgbbL4D_qTQu-4" value="" style="rounded=0;whiteSpace=wrap;html=1;" vertex="1" parent="1">
          <mxGeometry x="90" y="420" width="170" height="60" as="geometry" />
        </mxCell>
        <mxCell id="BxyisJofKgbbL4D_qTQu-9" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" edge="1" parent="1" source="BxyisJofKgbbL4D_qTQu-5" target="BxyisJofKgbbL4D_qTQu-6">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="BxyisJofKgbbL4D_qTQu-5" value="" style="rounded=0;whiteSpace=wrap;html=1;" vertex="1" parent="1">
          <mxGeometry x="520" y="420" width="120" height="60" as="geometry" />
        </mxCell>
        <mxCell id="BxyisJofKgbbL4D_qTQu-6" value="" style="rounded=0;whiteSpace=wrap;html=1;" vertex="1" parent="1">
          <mxGeometry x="770" y="420" width="120" height="60" as="geometry" />
        </mxCell>
        <mxCell id="BxyisJofKgbbL4D_qTQu-7" value="" style="rounded=0;whiteSpace=wrap;html=1;" vertex="1" parent="1">
          <mxGeometry x="980" y="420" width="120" height="60" as="geometry" />
        </mxCell>
        <mxCell id="BxyisJofKgbbL4D_qTQu-8" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="BxyisJofKgbbL4D_qTQu-1" target="BxyisJofKgbbL4D_qTQu-4">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="110" y="260" />
              <mxPoint x="110" y="310" />
              <mxPoint x="175" y="310" />
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="BxyisJofKgbbL4D_qTQu-11" value="AWS S3 BUCKETS" style="rounded=0;whiteSpace=wrap;html=1;" vertex="1" parent="1">
          <mxGeometry x="435" y="200" width="180" height="30" as="geometry" />
        </mxCell>
        <mxCell id="BxyisJofKgbbL4D_qTQu-12" value="stage 1&lt;br&gt;download_new_quarter_from_fda.sh" style="text;html=1;align=center;verticalAlign=middle;resizable=0;points=[];autosize=1;strokeColor=none;fillColor=none;" vertex="1" parent="1">
          <mxGeometry x="40" y="290" width="220" height="40" as="geometry" />
        </mxCell>
        <mxCell id="BxyisJofKgbbL4D_qTQu-13" value="BASE_FILE_DIR/data_new" style="text;html=1;align=center;verticalAlign=middle;resizable=0;points=[];autosize=1;strokeColor=none;fillColor=none;" vertex="1" parent="1">
          <mxGeometry x="90" y="435" width="170" height="30" as="geometry" />
        </mxCell>
        <mxCell id="BxyisJofKgbbL4D_qTQu-15" value="&lt;div&gt;napdi-cem-sandbox-files/&lt;span style=&quot;background-color: initial;&quot;&gt;data/&lt;/span&gt;&lt;span style=&quot;background-color: initial;&quot;&gt;faers/&amp;lt;domain&amp;gt;/YYYY/Q&amp;lt;#&amp;gt;/&lt;/span&gt;&lt;/div&gt;" style="text;html=1;align=center;verticalAlign=middle;resizable=0;points=[];autosize=1;strokeColor=none;fillColor=none;" vertex="1" parent="1">
          <mxGeometry x="250" y="250" width="340" height="30" as="geometry" />
        </mxCell>
        <mxCell id="BxyisJofKgbbL4D_qTQu-16" value="stage_1&lt;br&gt;upload_new_quarter_from_fda.sh" style="text;html=1;align=center;verticalAlign=middle;resizable=0;points=[];autosize=1;strokeColor=none;fillColor=none;" vertex="1" parent="1">
          <mxGeometry x="214" y="330" width="200" height="40" as="geometry" />
        </mxCell>
        <mxCell id="BxyisJofKgbbL4D_qTQu-17" value="add new quarter" style="text;html=1;align=center;verticalAlign=middle;resizable=0;points=[];autosize=1;strokeColor=none;fillColor=none;" vertex="1" parent="1">
          <mxGeometry x="490" y="130" width="110" height="30" as="geometry" />
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
