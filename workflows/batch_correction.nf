
include { MERGE_REPORTS } from "../modules/batch_report.nf"
include { FILTER_IMPUTE_NORMALIZE } from "../modules/batch_report.nf"
include { GENERATE_BATCH_RMD } from "../modules/batch_report.nf"
include { RENDER_BATCH_RMD } from "../modules/batch_report.nf"

workflow batch_correction {
    take:
        study_names
        metadatas
        replicate_reports
        precursor_reports

    main:

        // Merge tsv reports into database and render rmd report
        MERGE_REPORTS(study_names.collect(), replicate_reports.collect(),
                      precursor_reports.collect(), metadatas.collect())
        FILTER_IMPUTE_NORMALIZE(MERGE_REPORTS.out.final_db)
        GENERATE_BATCH_RMD(FILTER_IMPUTE_NORMALIZE.out.final_db)
        RENDER_BATCH_RMD(GENERATE_BATCH_RMD.out.bc_rmd, FILTER_IMPUTE_NORMALIZE.out.final_db)

        final_db = FILTER_IMPUTE_NORMALIZE.out.final_db
        bc_rmd = GENERATE_BATCH_RMD.out.bc_rmd
        bc_html = RENDER_BATCH_RMD.out.bc_html
        bc_tsv_reports = RENDER_BATCH_RMD.out.tsv_reports

    emit:
        final_db
        bc_rmd
        bc_html
        bc_tsv_reports
}
