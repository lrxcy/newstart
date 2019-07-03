package main

import (
    "log"

    sdk "github.com/gaia-pipeline/gosdk"
)

// This is one job. Add more if you want.
func DoSomethingAwesome(args sdk.Arguments) error {
    log.Println("This output will be streamed back to gaia and will be displayed in the pipeline logs.")

    // An error occured? Return it back so gaia knows that this job failed.
    return nil
}

func main() {
    jobs := sdk.Jobs{
        sdk.Job{
            Handler:     DoSomethingAwesome,
            Title:       "DoSomethingAwesome",
            Description: "This job does something awesome.",
        },
    }

    // Serve
    if err := sdk.Serve(jobs); err != nil {
        panic(err)
    }
}
