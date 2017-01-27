
stuff = LOAD '/tmp/wat-files/CC-MAIN-20161202170900-00000-ip-10-31-129-80.ec2.internal.warc.wat.gz'
	using JsonLoader('(Envelope:{(WARCHeaderLength:chararray,
				      BlockDigest:chararray,
				      Format:chararray,
				      ActualContentLength:chararray,
				      WarcHeaderMetaData:{})},
			  Container:{(Compressed:chararray, 
				      Offset:chararray, 
				      Filename:chararray, 
				      GzipMetadata:{})})') 
	AS (Envelope:{(WARCHeaderLength:chararray,
				      BlockDigest:chararray,
				      Format:chararray,
				      ActualContentLength:chararray,
				      WarcHeaderMetaData:{})},
			  Container:{(Compressed:chararray, 
				      Offset:chararray, 
				      Filename:chararray, 
				      GzipMetadata:{})});

dump stuff;

