<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;
use Illuminate\Mail\Mailables\Attachment;

class mailPMS extends Mailable
{
    use Queueable, SerializesModels;
    public $data;
    public $attachedFile;
    /**
     * Create a new message instance.
     *
     * @return void
     */
    public function __construct($data)
    {
        $this->data = $data;
    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        $subject = $this->data['subject'];
        $aksi = $this->data['aksi'];
        $body = [
            'dataBody' => $this->data['dataBody']
        ];

        // dd($aksi);

        if ($aksi == 'SubmitLPBJ') {
            return $this->subject($subject)
                ->view('mail.lpbj', $body);
        }

        if ($aksi == 'ApproveLPBJ') {
            return $this->subject($subject)
                ->view('mail.applpbj', $body);
        }

        if ($aksi == 'RejectLPBJ') {
            return $this->subject($subject)
                ->view('mail.rjklpbj', $body);
        }

        if ($aksi == 'SubmitQE') {
            return $this->subject($subject)
                ->view('mail.pengajuanqe', $body);
        }

        if ($aksi == 'ApproveQE') {
            return $this->subject($subject)
                ->view('mail.appqe', $body);
        }

        if ($aksi == 'RejectQE') {
            return $this->subject($subject)
                ->view('mail.rjkqe', $body);
        }

        if ($aksi == 'ResetPass') {
            return $this->subject($subject)
                ->view('mail.resetpass', $body);
        }

        if ($aksi == 'TestEmail') {
            return $this->subject($subject)
                ->view('mail.testemail');
        }
    }

    /**
     * Get the attachments for the message.
     *
     * @return array
     */
    // public function attachments()
    // {
    //     return [
    //         Attachment::fromPath($this->attachedFile),
    //     ];
    // }
}
