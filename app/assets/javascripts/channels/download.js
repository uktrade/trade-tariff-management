function subscribeDownloadChannel(uuid, callback) {
  App.download = App.cable.subscriptions.create(
    { channel: "DownloadChannel", uuid: uuid },
    {
      connected: function() {
        callback();
      },

      disconnected: function() {},

      received: function(data) {
        var blob = new Blob([data.csv], {
          type: "text/csv;charset=utf-8"
        });

        saveAs(blob, "measures_download_" + new Date().toISOString().slice(0, 10) +".csv");

        $("#download_measures")
          .prop('value', 'Download as CSV')
          .removeAttr("disabled");

        App.download.unsubscribe();
        App.cable.disconnect();
        delete App.download;
      }
    }
  );
}
