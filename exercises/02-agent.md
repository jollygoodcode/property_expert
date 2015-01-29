# Agent Exercise

Create a Agent model with following requirements:

**Model name: Agent. Table name: agents.**

Columns:

- name, string
- company, string
- mobile, string
- email, string
- photo, string

Validations:

-   Agent must have a name, mobile, and company.
-   Mobile must be following format.

    ```
    7zxx xxxx - Mobile phone services (Starting 2015)
    8zxx xxxx - Mobile phone services
    9yxx xxxx - Mobile phone services (pager services until May 2012)

    x denotes 0 to 9
    y denotes 0 to 8 only.
    z denotes 1 to 9 only.
    ```

    Hint: Validate the format “with” following Regular Expression:

    ```ruby
    /[7-8][1-9][1-9]{2}[\s]+[1-9]{4}|[9][0-8][1-9]{2}\s[1-9]{4}/
    ```
