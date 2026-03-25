#!/usr/bin/python
# load file paths and set up json config
import json
import argparse
from datetime import datetime

def main() -> None:
    parser = argparse.ArgumentParser(
        description="Generate a config file for Seurat to CellXGene conversion."
    )
    parser.add_argument(
        "infile_path", type=str,
        help="Path to input seurat object <rds|qs2>."
        )
    parser.add_argument(
        "outfile_dir", type=str,
        help="Path to output directory for matrix files <./>."
        )
    parser.add_argument(
        "-r", "--report", type=str, default=None, 
        help="Path to output report file [{outfile_dir}/report.html]."
        )
    parser.add_argument(
        "-p", "--project", type=str, default=str(datetime.now()), 
        help="Name of project. [datetime.now()]"
        )
    parser.add_argument(
        "-c", "--outconfig", type=str, default="run_config.json", 
        help="Path to output config file. [run_config.json]"
        )
    parser.add_argument(
        "-g", "--gene-activity", type=str, nargs="+", default=None,
        help="Assay layer(s) with gene-level activity e.g. ATAC_data. Auto-detect if blank"
    )

    args = parser.parse_args()

    # R and python export all assays automatically if not provided
    config = {
        "infile": str(args.infile_path),
        "outdir": str(args.outfile_dir),
        "report": str(args.report or f"{args.outfile_dir}/report.html"),
        "assays": None,        
        "gene_activity": args.gene_activity,
        "scvi": {
            "detected": None,  
            "latent_file": None
        },
        "metadata": {
            "project": args.project,
            "date": str(datetime.now())
        }
    }

    with open(args.outconfig, "w") as f:
        json.dump(config, f, indent=2)
    print(f"Config written: {args.outconfig}")

if __name__ == "__main__":
    main()