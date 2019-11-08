s3fs malariagen-datalab /exports  -o passwd_file=passwd-3fs -o url="https://cog.sanger.ac.uk" -o umask=0007,uid=1000 \
	-o kernel_cache \
	-o max_background=1000 \
	-o max_stat_cache_size=100000 \
	-o multipart_size=52 \
	-o parallel_count=30 \
	-o multireq_max=30 \
	-o dbglevel=warn
