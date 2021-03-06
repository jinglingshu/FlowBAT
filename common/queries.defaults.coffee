queryPreSave = (userId, changes) ->

share.Queries.before.insert (userId, query) ->
  query._id = query._id || Random.id()
  now = new Date()
  startDate = moment.utc().format("YYYY/MM/DD:HH")
  _.defaults(query,
    name: ""
    cmd: ""
    exclusionsCmd: ""
    startDateType: "interval"
    startDateOffsetEnabled: false
    startDateOffset: "60"
    startDateEnabled: true
    startDate: startDate
    endDateEnabled: false
    endDate: ""
    sensorEnabled: false
    sensor: ""
    typesEnabled: false
    types: []
    daddressEnabled: false
    daddress: ""
    saddressEnabled: false
    saddress: ""
    anyAddressEnabled: false
    anyAddress: ""
    dipSetEnabled: false
    dipSet: null
    sipSetEnabled: false
    sipSet: null
    anySetEnabled: false
    anySet: null
    dportEnabled: false
    dport: ""
    sportEnabled: false
    sport: ""
    aportEnabled: false
    aport: ""
    dccEnabled: false
    dcc: []
    sccEnabled: false
    scc: []
    protocolEnabled: true
    protocol: "0-255"
    flagsAllEnabled: false
    flagsAll: ""
    activeTimeEnabled: false
    activeTime: ""
    additionalParametersEnabled: false
    additionalParameters: ""
    additionalExclusionsCmdEnabled: false
    additionalExclusionsCmd: ""
    fields: ["sIP", "dIP", "sPort", "dPort", "protocol", "packets", "bytes", "flags", "sTime", "duration", "eTime", "sensor"]
    fieldsOrder: _.clone(share.rwcutFields)
    rwstatsDirection: "top"
    rwstatsMode: "count"
    rwstatsCountModeValue: "10"
    rwstatsThresholdModeValue: ""
    rwstatsPercentageModeValue: ""
    rwstatsBinTimeEnabled: false
    rwstatsBinTime: "60"
    rwstatsFields: []
    rwstatsFieldsOrder: _.clone(share.rwcutFields)
    rwstatsValues: []
    rwstatsValuesOrder: share.rwstatsValues.concat(share.rwcutFields)
    rwstatsPrimaryValue: ""
    rwstatsCmd: ""
    rwcountBinSizeEnabled: false
    rwcountBinSize: ""
    rwcountLoadSchemeEnabled: false
    rwcountLoadScheme: ""
    rwcountSkipZeroes: true
    rwcountFields: _.clone(share.rwcountFields)
    rwcountCmd: ""
    interface: "cmd"
    output: "rwcut"
    presentation: "table"
    chartType: "LineChart"
    chartHeight: 400
    expandedFieldsets: ["time"]
    executingInterval: 0
    executingAt: null
    isInputStale: false
    isOutputStale: false
    isUTC: true
    isQuick: false
    isNew: true
    ownerId: userId
    updatedAt: now
    createdAt: now
  , share.queryResetValues)
  if not query.name
    prefix = "New query"
    count = share.Queries.find({ name: { $regex: "^" + prefix, $options: "i" } }).count()
    query.name = prefix
    if count
      query.name += " (" + count + ")"
  queryPreSave.call(@, userId, query)

share.Queries.before.update (userId, query, fieldNames, modifier, options) ->
  now = new Date()
  modifier.$set = modifier.$set or {}
  modifier.$set.updatedAt = modifier.$set.updatedAt or now
  queryPreSave.call(@, userId, modifier.$set)

share.queryResetValues =
  result: ""
  error: ""
  startRecNum: 1
  sortField: ""
  sortReverse: true
  chartHiddenFields: []