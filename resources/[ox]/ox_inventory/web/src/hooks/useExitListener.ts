import { useEffect, useRef } from 'react';

import { noop } from '../utils/misc';
import { fetchNui } from '../utils/fetchNui';
import { closeTooltip } from '../store/tooltip';
import { useAppDispatch } from '../store';
import { closeContextMenu } from '../store/contextMenu';

type FrameVisibleSetter = (bool: boolean) => void;

export const useExitListener = (visibleSetter: FrameVisibleSetter) => {
  const setterRef = useRef<FrameVisibleSetter>(noop);
  const dispatch = useAppDispatch();

  useEffect(() => {
    setterRef.current = visibleSetter;
  }, [visibleSetter]);

  useEffect(() => {
    const keyHandler = (e: KeyboardEvent) => {
      if (e.repeat) return;

      if (e.code === 'Tab') {
        e.preventDefault();
        e.stopPropagation();

        const activeElement = document.activeElement;
        const inputFocused =
          activeElement instanceof HTMLInputElement ||
          activeElement instanceof HTMLTextAreaElement;

        if (!inputFocused) return;

        activeElement.blur();

        setterRef.current(false);
        dispatch(closeTooltip());
        dispatch(closeContextMenu());
        fetchNui('exit');

        return;
      }

      if (e.code === 'Escape') {
        e.preventDefault();
        e.stopPropagation();

        if (document.activeElement instanceof HTMLElement) {
          document.activeElement.blur();
        }

        setterRef.current(false);
        dispatch(closeTooltip());
        dispatch(closeContextMenu());
        fetchNui('exit');
      }
    };

    window.addEventListener('keydown', keyHandler, true);

    return () => window.removeEventListener('keydown', keyHandler, true);
  }, []);
};