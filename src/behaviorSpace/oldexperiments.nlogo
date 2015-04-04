
  <experiment name="NoNoise60KticksPast6KBurnin40runs" repetitions="40" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="66000"/>
    <metric>previous-seed</metric>
    <metric>normalize-buckets relig-type-years-buckets</metric>
    <metric>mean [relig-type] of subaks</metric>
    <metric>stddev [relig-type] of subaks</metric>
    <metric>avgharvestha</metric>
    <metric>max-avgharvestha</metric>
    <metric>avgWS</metric>
    <metric>avgpestloss</metric>
    <enumeratedValueSet variable="burn-in-months">
      <value value="6000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ignore-neighbors-prob">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-pestneighbors">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="subaks-mean-global">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-curve">
      <value value="&quot;linear&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-step">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-center">
      <value value="2.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-endpt">
      <value value="1.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="run-until-month">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-tran-stddev">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-seed-source">
      <value value="&quot;new seed&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-relig-types">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-subak-values">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="NoiseNoRelig60KticksPast6KBurnin40runs" repetitions="40" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="66000"/>
    <metric>previous-seed</metric>
    <metric>normalize-buckets relig-type-years-buckets</metric>
    <metric>mean [relig-type] of subaks</metric>
    <metric>stddev [relig-type] of subaks</metric>
    <metric>avgharvestha</metric>
    <metric>max-avgharvestha</metric>
    <metric>avgWS</metric>
    <metric>avgpestloss</metric>
    <enumeratedValueSet variable="burn-in-months">
      <value value="6000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ignore-neighbors-prob">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-pestneighbors">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="subaks-mean-global">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-curve">
      <value value="&quot;linear&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-step">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-center">
      <value value="2.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-endpt">
      <value value="1.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="run-until-month">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-tran-stddev">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-seed-source">
      <value value="&quot;new seed&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-relig-types">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-subak-values">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="NoiseReligLinear60KticksPast6KBurnin3x40runs" repetitions="40" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="66000"/>
    <metric>previous-seed</metric>
    <metric>normalize-buckets relig-type-years-buckets</metric>
    <metric>mean [relig-type] of subaks</metric>
    <metric>stddev [relig-type] of subaks</metric>
    <metric>avgharvestha</metric>
    <metric>max-avgharvestha</metric>
    <metric>avgWS</metric>
    <metric>avgpestloss</metric>
    <enumeratedValueSet variable="burn-in-months">
      <value value="6000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ignore-neighbors-prob">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-pestneighbors">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="subaks-mean-global">
      <value value="0.025"/>
      <value value="1"/>
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-curve">
      <value value="&quot;linear&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-step">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-center">
      <value value="2.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-endpt">
      <value value="1.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="run-until-month">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-tran-stddev">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-seed-source">
      <value value="&quot;new seed&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-relig-types">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-subak-values">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="NoiseRelig08step60KticksPast6KBurnin3x40runs" repetitions="40" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="66000"/>
    <metric>previous-seed</metric>
    <metric>normalize-buckets relig-type-years-buckets</metric>
    <metric>mean [relig-type] of subaks</metric>
    <metric>stddev [relig-type] of subaks</metric>
    <metric>avgharvestha</metric>
    <metric>max-avgharvestha</metric>
    <metric>avgWS</metric>
    <metric>avgpestloss</metric>
    <enumeratedValueSet variable="burn-in-months">
      <value value="6000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ignore-neighbors-prob">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-pestneighbors">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="subaks-mean-global">
      <value value="0.025"/>
      <value value="1"/>
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-curve">
      <value value="&quot;step&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-step">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-center">
      <value value="2.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-endpt">
      <value value="1.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="run-until-month">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-tran-stddev">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-seed-source">
      <value value="&quot;new seed&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-relig-types">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-subak-values">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="NoiseRelig225and170sigmoidey60KticksPast6KBurnin3x40runs" repetitions="40" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="66000"/>
    <metric>previous-seed</metric>
    <metric>normalize-buckets relig-type-years-buckets</metric>
    <metric>mean [relig-type] of subaks</metric>
    <metric>stddev [relig-type] of subaks</metric>
    <metric>avgharvestha</metric>
    <metric>max-avgharvestha</metric>
    <metric>avgWS</metric>
    <metric>avgpestloss</metric>
    <enumeratedValueSet variable="burn-in-months">
      <value value="6000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ignore-neighbors-prob">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-pestneighbors">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="subaks-mean-global">
      <value value="0.025"/>
      <value value="1"/>
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-curve">
      <value value="&quot;sigmoidey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-step">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-center">
      <value value="2.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-endpt">
      <value value="1.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="run-until-month">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-tran-stddev">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-seed-source">
      <value value="&quot;new seed&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-relig-types">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-subak-values">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="NoiseRelig05step60KticksPast6KBurnin3x40runs" repetitions="40" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="66000"/>
    <metric>previous-seed</metric>
    <metric>normalize-buckets relig-type-years-buckets</metric>
    <metric>mean [relig-type] of subaks</metric>
    <metric>stddev [relig-type] of subaks</metric>
    <metric>avgharvestha</metric>
    <metric>max-avgharvestha</metric>
    <metric>avgWS</metric>
    <metric>avgpestloss</metric>
    <enumeratedValueSet variable="burn-in-months">
      <value value="6000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ignore-neighbors-prob">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-pestneighbors">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="subaks-mean-global">
      <value value="0.025"/>
      <value value="1"/>
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-curve">
      <value value="&quot;step&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-step">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-center">
      <value value="2.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-endpt">
      <value value="1.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="run-until-month">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-tran-stddev">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-seed-source">
      <value value="&quot;new seed&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-relig-types">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-subak-values">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="NoiseRelig05step0025global60KticksPast6KBurnin40runs" repetitions="40" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="66000"/>
    <metric>previous-seed</metric>
    <metric>normalize-buckets relig-type-years-buckets</metric>
    <metric>mean [relig-type] of subaks</metric>
    <metric>stddev [relig-type] of subaks</metric>
    <metric>avgharvestha</metric>
    <metric>max-avgharvestha</metric>
    <metric>avgWS</metric>
    <metric>avgpestloss</metric>
    <enumeratedValueSet variable="burn-in-months">
      <value value="6000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ignore-neighbors-prob">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-pestneighbors">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="subaks-mean-global">
      <value value="0.025"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-curve">
      <value value="&quot;step&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-step">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-center">
      <value value="2.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-endpt">
      <value value="1.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="run-until-month">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-tran-stddev">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-seed-source">
      <value value="&quot;new seed&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-relig-types">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-subak-values">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="NoiseRelig05step1global60KticksPast6KBurnin40runs" repetitions="40" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="66000"/>
    <metric>previous-seed</metric>
    <metric>normalize-buckets relig-type-years-buckets</metric>
    <metric>mean [relig-type] of subaks</metric>
    <metric>stddev [relig-type] of subaks</metric>
    <metric>avgharvestha</metric>
    <metric>max-avgharvestha</metric>
    <metric>avgWS</metric>
    <metric>avgpestloss</metric>
    <enumeratedValueSet variable="burn-in-months">
      <value value="6000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ignore-neighbors-prob">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-pestneighbors">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="subaks-mean-global">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-curve">
      <value value="&quot;step&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-step">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-center">
      <value value="2.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-endpt">
      <value value="1.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="run-until-month">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-tran-stddev">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-seed-source">
      <value value="&quot;new seed&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-relig-types">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-subak-values">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="NoiseRelig05step50global60KticksPast6KBurnin40runs" repetitions="40" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="66000"/>
    <metric>previous-seed</metric>
    <metric>normalize-buckets relig-type-years-buckets</metric>
    <metric>mean [relig-type] of subaks</metric>
    <metric>stddev [relig-type] of subaks</metric>
    <metric>avgharvestha</metric>
    <metric>max-avgharvestha</metric>
    <metric>avgWS</metric>
    <metric>avgpestloss</metric>
    <enumeratedValueSet variable="burn-in-months">
      <value value="6000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ignore-neighbors-prob">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-pestneighbors">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="subaks-mean-global">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-curve">
      <value value="&quot;step&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-step">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-center">
      <value value="2.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-endpt">
      <value value="1.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="run-until-month">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-tran-stddev">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-seed-source">
      <value value="&quot;new seed&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-relig-types">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-subak-values">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="NoiseRelig08step0025global60KticksPast6KBurnin40runs" repetitions="40" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="66000"/>
    <metric>previous-seed</metric>
    <metric>normalize-buckets relig-type-years-buckets</metric>
    <metric>mean [relig-type] of subaks</metric>
    <metric>stddev [relig-type] of subaks</metric>
    <metric>avgharvestha</metric>
    <metric>max-avgharvestha</metric>
    <metric>avgWS</metric>
    <metric>avgpestloss</metric>
    <enumeratedValueSet variable="burn-in-months">
      <value value="6000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ignore-neighbors-prob">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-pestneighbors">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="subaks-mean-global">
      <value value="0.025"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-curve">
      <value value="&quot;step&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-step">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-center">
      <value value="2.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-endpt">
      <value value="1.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="run-until-month">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-tran-stddev">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-seed-source">
      <value value="&quot;new seed&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-relig-types">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-subak-values">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="NoiseRelig08step1global60KticksPast6KBurnin40runs" repetitions="40" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="66000"/>
    <metric>previous-seed</metric>
    <metric>normalize-buckets relig-type-years-buckets</metric>
    <metric>mean [relig-type] of subaks</metric>
    <metric>stddev [relig-type] of subaks</metric>
    <metric>avgharvestha</metric>
    <metric>max-avgharvestha</metric>
    <metric>avgWS</metric>
    <metric>avgpestloss</metric>
    <enumeratedValueSet variable="burn-in-months">
      <value value="6000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ignore-neighbors-prob">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-pestneighbors">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="subaks-mean-global">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-curve">
      <value value="&quot;step&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-step">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-center">
      <value value="2.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-endpt">
      <value value="1.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="run-until-month">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-tran-stddev">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-seed-source">
      <value value="&quot;new seed&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-relig-types">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-subak-values">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="NoiseRelig08step50global60KticksPast6KBurnin40runs" repetitions="40" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="66000"/>
    <metric>previous-seed</metric>
    <metric>normalize-buckets relig-type-years-buckets</metric>
    <metric>mean [relig-type] of subaks</metric>
    <metric>stddev [relig-type] of subaks</metric>
    <metric>avgharvestha</metric>
    <metric>max-avgharvestha</metric>
    <metric>avgWS</metric>
    <metric>avgpestloss</metric>
    <enumeratedValueSet variable="burn-in-months">
      <value value="6000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ignore-neighbors-prob">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-pestneighbors">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="subaks-mean-global">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-curve">
      <value value="&quot;step&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-step">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-center">
      <value value="2.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-endpt">
      <value value="1.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="run-until-month">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-tran-stddev">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-seed-source">
      <value value="&quot;new seed&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-relig-types">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-subak-values">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="NoiseRelig225and170sigmoidey0025global60KticksPast6KBurnin40runs" repetitions="40" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="66000"/>
    <metric>previous-seed</metric>
    <metric>normalize-buckets relig-type-years-buckets</metric>
    <metric>mean [relig-type] of subaks</metric>
    <metric>stddev [relig-type] of subaks</metric>
    <metric>avgharvestha</metric>
    <metric>max-avgharvestha</metric>
    <metric>avgWS</metric>
    <metric>avgpestloss</metric>
    <enumeratedValueSet variable="burn-in-months">
      <value value="6000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ignore-neighbors-prob">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-pestneighbors">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="subaks-mean-global">
      <value value="0.025"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-curve">
      <value value="&quot;sigmoidey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-step">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-center">
      <value value="2.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-endpt">
      <value value="1.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="run-until-month">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-tran-stddev">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-seed-source">
      <value value="&quot;new seed&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-relig-types">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-subak-values">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="NoiseRelig225and170sigmoidey1global60KticksPast6KBurnin40runs" repetitions="40" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="66000"/>
    <metric>previous-seed</metric>
    <metric>normalize-buckets relig-type-years-buckets</metric>
    <metric>mean [relig-type] of subaks</metric>
    <metric>stddev [relig-type] of subaks</metric>
    <metric>avgharvestha</metric>
    <metric>max-avgharvestha</metric>
    <metric>avgWS</metric>
    <metric>avgpestloss</metric>
    <enumeratedValueSet variable="burn-in-months">
      <value value="6000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ignore-neighbors-prob">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-pestneighbors">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="subaks-mean-global">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-curve">
      <value value="&quot;sigmoidey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-step">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-center">
      <value value="2.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-endpt">
      <value value="1.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="run-until-month">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-tran-stddev">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-seed-source">
      <value value="&quot;new seed&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-relig-types">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-subak-values">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="NoiseRelig225and170sigmoidey50global60KticksPast6KBurnin40runs" repetitions="40" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="66000"/>
    <metric>previous-seed</metric>
    <metric>normalize-buckets relig-type-years-buckets</metric>
    <metric>mean [relig-type] of subaks</metric>
    <metric>stddev [relig-type] of subaks</metric>
    <metric>avgharvestha</metric>
    <metric>max-avgharvestha</metric>
    <metric>avgWS</metric>
    <metric>avgpestloss</metric>
    <enumeratedValueSet variable="burn-in-months">
      <value value="6000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ignore-neighbors-prob">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-pestneighbors">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="subaks-mean-global">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-curve">
      <value value="&quot;sigmoidey&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-step">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-center">
      <value value="2.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-effect-endpt">
      <value value="1.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="run-until-month">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-tran-stddev">
      <value value="0.02"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="relig-influence">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rainfall-scenario">
      <value value="&quot;high&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestdispersal-rate">
      <value value="1.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pestgrowth-rate">
      <value value="2.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="random-seed-source">
      <value value="&quot;new seed&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-a">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-b">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-c">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-d">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-e">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-f">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-g">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-h">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-i">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-j">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-k">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-l">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-m">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-n">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-o">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-p">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-q">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-r">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-s">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-t">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cropplan-u">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Color_subaks">
      <value value="&quot;cropping plans&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="viewdamsubaks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-relig-types">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="show-subak-values">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
