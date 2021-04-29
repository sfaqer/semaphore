#Использовать ".."

#Использовать asserts

&Тест
Процедура СемафорыСОдинаковымКлючомБлокируются() Экспорт

	Семафор1 = Семафоры.Получить("тестовый семафор");
	Семафор2 = Семафоры.Получить("тестовый семафор");

	Семафор1.Захватить();
	
	ПараметрыМетода = Новый Массив;
	ПараметрыМетода.Добавить(10);

	Ожидаем.Что(Семафор2).Метод("Захватить", ПараметрыМетода).ВыбрасываетИсключение("Истекло время ожидания");
	
	Семафор1.Освободить();
	
	Семафор2.Захватить(10);
	Семафор2.Освободить();

КонецПроцедуры

&Тест
Процедура СемафорыСРазнымиКлючамиНеБлокируются() Экспорт
	
	Семафор1 = Семафоры.Получить("тестовый семафор 1");
	Семафор2 = Семафоры.Получить("тестовый семафор 2");
	
	Семафор1.Захватить();
	Семафор2.Захватить(10);
	
	Семафор1.Освободить();
	Семафор2.Освободить();

КонецПроцедуры

&Тест
Процедура СемафорыСОдинаковымКлючомБлокируютсяМногопоточно() Экспорт

	Параметры = Новый Массив(1);
	Параметры[0] = Ложь;

	ФоновыеЗадания.Выполнить(ЭтотОбъект, "СемафорыСОдинаковымКлючомБлокируютсяВМногопочтономРежиме", Параметры);

	Параметры[0] = Истина;

	ФоновыеЗадания.Выполнить(ЭтотОбъект, "СемафорыСОдинаковымКлючомБлокируютсяВМногопочтономРежиме", Параметры);
	ФоновыеЗадания.Выполнить(ЭтотОбъект, "СемафорыСОдинаковымКлючомБлокируютсяВМногопочтономРежиме", Параметры);
	ФоновыеЗадания.Выполнить(ЭтотОбъект, "СемафорыСОдинаковымКлючомБлокируютсяВМногопочтономРежиме", Параметры);
	ФоновыеЗадания.Выполнить(ЭтотОбъект, "СемафорыСОдинаковымКлючомБлокируютсяВМногопочтономРежиме", Параметры);
	ФоновыеЗадания.Выполнить(ЭтотОбъект, "СемафорыСОдинаковымКлючомБлокируютсяВМногопочтономРежиме", Параметры);

	Попытка
		ФоновыеЗадания.ОжидатьЗавершенияЗадач();
	Исключение
		
		МассивЗаданий = ИнформацияОбОшибке().Параметры;

		Если МассивЗаданий <> Неопределено Тогда

			ШаблонТекстаОшибки = 
				"Ошибки при многопоточной работе семафора:
				|%1";

			Для Каждого Задание Из МассивЗаданий Цикл
				
				МассивОшибок = Новый Массив();
				МассивОшибок.Добавить(Задание.ИнформацияОбОшибке.ПодробноеОписаниеОшибки());

			КонецЦикла;

			ВызватьИсключение СтрШаблон(
				ШаблонТекстаОшибки,
				СтрСоединить(МассивОшибок, Символы.ПС)
			);

		КонецЕсли;
	КонецПопытки;

КонецПроцедуры

Процедура СемафорыСОдинаковымКлючомБлокируютсяВМногопочтономРежиме(ДолженВызватьИсключение) Экспорт
	
	Семафор = Семафоры.Получить("тестовый семафор");

	Если ДолженВызватьИсключение Тогда

		ПараметрыМетода = Новый Массив;
		ПараметрыМетода.Добавить(1000);
	
		Ожидаем.Что(Семафор).Метод("Захватить", ПараметрыМетода).ВыбрасываетИсключение("Истекло время ожидания");

	Иначе

		Семафор.Захватить();
		Приостановить(3000);
		Семафор.Освободить();

	КонецЕсли;

КонецПроцедуры
