import React from 'react';
import './CliLayout.css';

interface CliQuestion {
  question: string;
  comment?: string;
  options?: CliOption[];
}

interface CliOption {
  label: string;
  selected?: boolean;
}

interface CliLayoutProps {
  questions: CliQuestion[];
}

export const CliLayout: React.FC<CliLayoutProps> = ({ questions }) => {
  return (
    <div className="cli-terminal">
      {questions.map((q, index) => (
        <React.Fragment key={index}>
          <div>
            <span className="cli-prompt">?</span> <span className="cli-question">{q.question}</span>
            {q.comment && <span className="cli-comment"> {q.comment}</span>}
          </div>
          {q.options && (
            <div className="cli-option">
              {q.options.map((opt, optIndex) => (
                <div key={optIndex}>
                  <span className="cli-comment">{opt.selected ? '◉' : '◯'}</span>{' '}
                  <span className="cli-target">{opt.label}</span>
                </div>
              ))}
            </div>
          )}
        </React.Fragment>
      ))}
    </div>
  );
};

