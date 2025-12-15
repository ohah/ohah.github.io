import React, { useRef, useEffect } from 'react';
import { commentStore } from './commentStore';
import './Comment.css';

interface CommentProps {
  children: React.ReactNode;
  note: string;
}

export const Comment: React.FC<CommentProps> = ({ children, note }) => {
  const [commentId, setCommentId] = React.useState<number | null>(null);
  const containerRef = useRef<HTMLSpanElement>(null);

  useEffect(() => {
    if (containerRef.current && !commentId) {
      const elementId = `comment-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
      containerRef.current.id = elementId;
      const id = commentStore.addComment(note, elementId);
      setCommentId(id);
    }
  }, [note, commentId]);

  const handleNumberClick = (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();
    if (commentId !== null) {
      // 위에서 클릭한 경우 하단으로도 스크롤
      commentStore.scrollToComment(commentId, true);
    }
  };

  return (
    <span ref={containerRef} className="comment-container">
      <span className="comment-text">{children}</span>
      {commentId !== null && (
        <sup className="comment-number-badge" onClick={handleNumberClick}>
          [{commentId}]
        </sup>
      )}
      <span className="comment-tooltip">{note}</span>
    </span>
  );
};
